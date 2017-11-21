---
comments: true
date: 2014-05-26T21:14:07Z
tags:
- ssh
- keygen
- automation
- api
title: Automate SSH Key Generation and Deployment
url: /blog/2014/05/26/automate-ssh-key-generation-and-deployment/
---

I recently pieced together a bash wrapper script to create, add, and delete an ssh key for temporary use in performing remote tasks over ssh. The processes outlined here assume cURL is available, and that the remote service you wish to connect to has API methods for ssh key handling.

Automating the process of generating and deleting a local ssh key is the easy part. Here's one way to create a key:

```bash
ssh-keygen -q -b 4096 -t rsa -N "" -f ./scripted.key
```

__Options rundown:__

- -b bit strength -> higher than the default 2048
- -f filename     -> easier to subsequently delete the keypair
- -N passphrase   -> empty string
- -q quiet mode   -> no need to review output
- -t key type     -> specify rsa

And now to delete the newly created key-pair:

```bash
rm -r ./scripted.key*
```

Next we'll set up the API calls to register and delete a public key on remote services, in this case Github and Acquia.

## Github

To automate ssh key deployment on Github, you'll first want to generate a personal access token under 'Account settings' > 'Applications'. We'll set a variable to the value of the token for easy re-use:

```bash
TOKEN='your-token'
```

Per [the docs](https://developer.github.com/v3/users/keys/), note that the `DELETE` operation we will eventually employ requires a special `admin:public_key` permission.

In addition to the token, we'll set another variable to the value of the ssh public key as follows:

```bash
PUBKEY=`cat ./script.key.pub`
```

Now we can cURL the Github API using the `TOKEN` and `PUBKEY` variables. Since we're setting up for a procedural operation and to reduce the number of network requests, we'll capture the Github API response (which contains the key ID):

```bash
RESPONSE=`curl -s -H "Authorization: token ${TOKEN}" \
  -X POST --data-binary "{\"title\":\"nr@blackhole\",\"key\":\"${PUBKEY}\"}" \
  https://api.github.com/user/keys`
```

And now to extract the key ID:

```bash
KEYID=`echo $RESPONSE \
  | grep -o '\"id.*' \
  | grep -o "[0-9]*" \
  | grep -m 1 "[0-9]*"`
```

Note that the above is more than we really need to be able to parse the Github response. With the Acquia example (coming up next), we'll see a good reason for setting up the extraction in this manner.

_Only one step left, but you may want to add a 10-second sleep to the script to give an opportunity to verify that the key was added before it is deleted._

And now for the delete:

```bash
curl -s -H "Authorization: token ${TOKEN}" -X DELETE \
   https://api.github.com/user/keys/${KEYID} \
  -o /dev/null
```

Here we're sending the result to `/dev/null` to ensure the script stays quiet.

## Acquia

Performing this task with Acquia's Cloud API is much the same, but with a couple of notable differences.

First, we need to set a couple of additional variables:

```bash
CLOUDAPI_ID='id'
CLOUDAPI_KEY='key'
DOCROOT="docroot"
CREDS="${CLOUDAPI_ID}:${CLOUDAPI_KEY}"
```

Variables set, here's the cURL command to add the key:

```bash
RESPONSE=`curl -s -u $CREDS \
  -X POST --data-binary "{\"ssh_pub_key\":\"${PUBKEY}\"}" \
  https://cloudapi.acquia.com/v1/sites/"${DOCROOT}"/sshkeys.json?nickname=script`
```

In this case, we're going to extract 2 pieces of data from the response. We'll need the task ID to track the status of adding the key, and we'll also need the key ID (as with the Github example) so that we can delete the key:

```bash
TASKID=`echo $RESPONSE \
  | grep -o '\"id.*' \
  | grep -o "[0-9]*" \
  | grep -m 1 "[0-9]*"`

KEYID=`echo $RESPONSE \
  | grep -o "sshkeyid.*" \
  | grep -o "[0-9]*" \
  | grep -m 1 "[0-9]*"`
```

This is where the utility of the extra bash logic comes in handy, as the Acquia response is condensed JSON, whereas the Github response is readable JSON. Since we don't have things nicely separated into lines, and since we want to minimize dependencies (this is where I'd otherwise recommend jq), the above gives us what we need with fairly low overhead.

Now to query the task ID so we know when we can start using our key:

```bash
STATUS='null'
until [[ $STATUS =~ ^error|done$ ]]; do
  STATUS=`curl -s -u $CREDS \
  https://cloudapi.acquia.com/v1/sites/"${DOCROOT}"/tasks/"${TASKID}".json \
  | grep -o 'state.*' \
  | grep -o '[a-z]*' \
  | sed -n 2p`
  echo "ADDING SSH KEY: ${STATUS}"
  sleep 5
done
```

And finally, here's the delete:

```bash
curl -s -u $CREDS -X DELETE \
  https://cloudapi.acquia.com/v1/sites/"${DOCROOT}"/sshkeys/"${SSHID}".json \
  -o /dev/null
```


For reference, I set up a [Gist](https://gist.github.com/nhoag/7043570bfe32003eb8a1) that contains complete bash scripts for both services covered above.

### Enjoy!

