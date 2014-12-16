# Pairbot

### A simple [hubot](https://hubot.github.com) script to support pair programming.

The initial use case is pretty specific:

> As a developer pairing with another developer (my pair), both on an IRC channel,
> I'd like to get messages that mention me forwarded to my pair,
> so that I can see them.

But there might be other use cases in the future.

See [`src/pairbot.coffee`](src/pairbot.coffee) for full documentation.

## Installation

Add **hubot-pairbot** to your `package.json` file:

```json
"dependencies": {
    "hubot-pairbot": ">=0.0.0"
}
```

Add **hubot-pairbot** to your `external-scripts.json`:

```json
["hubot-pairbot"]
```

Run `npm install hubot-pairbot`

## Commands

Most commands have multiple aliases and abbreviations. See the commands object [`src/pairbot.coffee`](src/pairbot.coffee) for details.

```start pairing with <pair>```

Registers a pairing. Messages sent to the user will be forwarded to the pair. Note that only one pairing per user is supported.

```stop pairing```

Removes the pairing registation. Messages will no longer be forwarded.

```list pairs```

See all the current pairings known to pairbot.

```clear pairs```

Removes all registrations. Use with caution.

```help```

Quick list of commands.

## Sample Interaction

coming soon.

