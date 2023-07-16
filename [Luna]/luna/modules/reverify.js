const Discord = require('discord.js');
const express = require('express');
const app = express();
app.use(express.json()); // for parsing application/json

const client = new Discord.Client();
client.login('MTExMDM5MTk0MjM1NDgyOTQ0Mw.GypRX8.1ykyYxchkTG-ssInrfrnzpF2jGU38_gfasMVJM');

app.post('/send_verification_code', (req, res) => {
    const { discord_id, verification_code } = req.body;
    client.users.fetch(discord_id).then((user) => {
        user.send(`Your verification code is: ${verification_code}`)
        .then(() => res.sendStatus(200)) 
        .catch((err) => {
            console.log(err);
            res.sendStatus(500);
        });
    }).catch((err) => {
        console.log(err);
        res.sendStatus(500);
    });
});

app.listen(3000, () => console.log('Server started'));
