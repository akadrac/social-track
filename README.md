# social-track

This is a lambda function to check a twitter users timeline and post any new tweets to a discord webhook.

It uses dynamodbo to store the screen_name, since_id (the last twitter id seen) and exclude_replies (boolean).

You need to create a table (social-track) and add the entires for each user you want to follow.

You need to create a KMS encrypted secrets file containing the twitter api key and api secret and the discord webhook.

Modify `encrypt.cmd` as necessary, to create the encrypted file (for windows)

Build the application with `docker run -t social-track .`

Copy the zip file out of the docker container with `docker container cp <name>:/dist/app.zip .`

Update to the zip file to the Lambda function you have created (nodejs 6.10)

Add a trigger of cloudwatch with a 5-min interval.

enjoy!
