TgBot = require 'node-telegram-bot-api'
request = require 'request'

token = require './settings'
bot = new TgBot token,
    polling: true

bot.on 'message', (msg) ->
    url = 'http://api.nihongoresources.com/kanji/find/' + encodeURIComponent msg.text
    request url, (e, res, body) ->
        if !e and
        res.statusCode == 200 and
        body isnt '[]' and
        (JSON.parse body)[0] isnt false
            kanji = (JSON.parse body)[0]
            
            readings = ''
            for item in kanji.readings
                readings += "#{ item }、"
            readings = readings.slice(0, -1);
            meanings = ''
            for item in kanji.meanings
                meanings += "#{ item }, "
            meanings = meanings.slice(0, -2);
            
            data = "#{ kanji.literal }　【#{ readings }】"
            data += "\n_#{ meanings }_"
            bot.sendMessage msg.from.id, data,
                parse_mode: 'Markdown'
        else
            bot.sendMessage msg.from.id, "Sorry, couldn't get what you were looking for :("
