My scripts
==========

Those are intended to work with xmpp hubot adapter

askhimto
--------

A script to manage todo lists for several users.

You may ask anyone to do something and he or she will be able to run

````
  hubot todo
````

to list assigned stuff. In order to mark something done simply run


````
  hubot done *task_id*
````

git-hooks
---------

To be used together with commit-msg git hook

Will force hubot to announce commits by a user. Requires hubot http listener and curl on the client side.

git-payloads
------------

Announces pushes by a user. Requires serverside hook that does the post to the hubot listener.
