Usage
=====

Decisions
---------

 * `diskotappi: kumpi, X vai Y` returns either `X` or `Y`

Genre generator
---------------

 * `!genre phrase` returns a new music genre including `phrase`

Uri actions
-----------

Whenever a specific uri is pasted to the channel, the bot gives it's title.
Works for the following services:

 * Hearthis
 * Mixcloud
 * Resident Advisor
 * Soundcloud
 * Spotify
 * Twitter (content)
 * Vimeo
 * YLE Areena
 * Youtube
 * HS.fi

For every uri, if it's pasted already, the bot will complain that the link is
old.

For GIF animations, the bot will return the HTML5 version from Gfycat.

Megahal
-------

If addressing the bot, it will answer back using the megahal AI.

Weather
-------

 * `!w` returns the weather for London, Berlin and Helsinki
 * `!w place` returns the weather for the given place

Special places: `kertsi`, `sompasauna`.

Quote
-----

 * `!q` returns a random quote
 * `!q term` returns a quote including `term`
 * `!q add <nick> quote` adds a new quote to the database

Random mixtape
--------------

 * `!r` returns a random Soundcloud/Mixcloud uri from the database

Vice titles
-----------

 * `!vice` generates a mock Vice magazine title

Giphy
-----

 * `!giphy` display a random gif
 * `!giphy tag` display a random gif with a specific tag
