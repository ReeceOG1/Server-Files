// Made by Ker // (kerfoot) on discord //
// GMT Studios Copyright © 2023 //
// All rights reserved. Unauthorized use or distribution is strictly prohibited. //

const express = require('express');
const bodyParser = require('body-parser');
const { Webhook, MessageBuilder } = require('discord-webhook-node');
const config = require('./config');
const app = express();

// Listen this right here is the limit for pushing files since before adding a big file caused issues (2GB RECOMMENDED)
app.use(bodyParser.json({ limit: '2000mb' }));
app.use(bodyParser.urlencoded({ limit: '2000mb', extended: true }));

const hook = new Webhook(config.webhook);

// Reminder to put "/recieve_github" at the end of the github webhook like this [http://57.128.132.174:30145/recieve_github] 
app.post('/recieve_github', (req, res) => {
  const branchName = req.body.ref ? req.body.ref.split('/').pop() : '';

// Start of other updates 

  if (req.body.created) {
    const embed = new MessageBuilder()
      .setTitle(`[${req.body.sender.login}/${req.body.repository.name}] New branch created: ${branchName}`)
      .setAuthor(req.body.sender.login, req.body.sender.avatar_url, req.body.sender.html_url)
      .setURL(req.body.repository.html_url)
      .setColor('#14ff01')
      .setTimestamp();

    hook.send(embed);
  } else if (req.body.deleted) {
    const embed = new MessageBuilder()
      .setTitle(`[${req.body.sender.login}/${req.body.repository.name}] Branch deleted: ${branchName}`)
      .setAuthor(req.body.sender.login, req.body.sender.avatar_url, req.body.sender.html_url)
      .setURL(req.body.repository.html_url)
      .setColor('#fe0000')
      .setTimestamp();

    hook.send(embed);
  } else if (req.body.action === 'added') {
    const collaboratorName = req.body.member.login;

    const embed = new MessageBuilder()
      .setTitle(`[${req.body.sender.login}/${req.body.repository.name}] New collaborator added: ${collaboratorName}`)
      .setAuthor(req.body.sender.login, req.body.sender.avatar_url, req.body.sender.html_url)
      .setURL(req.body.repository.html_url)
      .setColor('#0040ff')
      .setTimestamp();

    hook.send(embed);
  } else if (req.body.action === 'started') {
    const embed = new MessageBuilder()
      .setTitle(`[${req.body.sender.login}/${req.body.repository.name}] Star added`)
      .setAuthor(req.body.sender.login, req.body.sender.avatar_url, req.body.sender.html_url)
      .setURL(req.body.repository.html_url)
      .setColor('#f5d742')
      .setTimestamp();

    hook.send(embed);
  } else if (req.body.action === 'forked') {
    const embed = new MessageBuilder()
      .setTitle(`[${req.body.sender.login}/${req.body.repository.name}] Repository forked`)
      .setAuthor(req.body.sender.login, req.body.sender.avatar_url, req.body.sender.html_url)
      .setURL(req.body.repository.html_url)
      .setColor('#ffa500')
      .setTimestamp();

    hook.send(embed);
  } else if (req.body.commits && req.body.commits.length > 0) {
    const embed = new MessageBuilder()
      .setTitle(`[${req.body.repository.name}:${branchName}]`)
      .setAuthor(req.body.sender.login, req.body.sender.avatar_url, req.body.sender.html_url)
      .setURL(req.body.repository.html_url)
      .setColor('#57f288')
      .setTimestamp();

// End of other updates d

    let commitFieldText = '';
    let numCommits = 0;

    for (let i in req.body.commits) {
      let message = req.body.commits[i].message;

      const revertPattern = /This reverts commit ([a-f0-9]{40})\./g;
      if (revertPattern.test(message)) {
        message = message.replace(revertPattern, '');
      }

      if (message.includes('Merge branch')) {
        message = message.split('\n').filter(line => !line.startsWith('Merge branch')).join('\n');
      }

      const commitLinkPattern = /\b[a-f0-9]{7} of https:\/\/github\.com\/[^\s]+\b/g;
      if (commitLinkPattern.test(message)) {
        message = message.replace(commitLinkPattern, '');
      }

      message = message.trim();

      if (message === '') {
        continue;
      }

      const lines = message.split('\n');

      let title = lines[0];
      let descriptionLines = lines.slice(1).filter(line => line.trim() !== '');

      if (descriptionLines.length > 1) {
        let description = descriptionLines.join('\n');
        message = title + '\n\n' + description;
      } else {
        message = title + (descriptionLines[0] ? '\n\n' + descriptionLines[0] : '');
      }

      commitFieldText += '[`' + req.body.commits[i].id.substring(0, 7) + '`](' + req.body.commits[i].url + ') ' + message + ' - ' + req.body.commits[i].author.username + '\n';
      numCommits++;
    }

    embed.setTitle(`[${req.body.repository.name}:${branchName}] ${numCommits} new commit${numCommits > 1 ? 's' : ''}`);

    if (commitFieldText !== '') {
      embed.addField('', commitFieldText);
    }

    hook.send(embed);
  }

  res.sendStatus(200);
});

app.listen(config.port, function () {
  console.log('Watching port ' + config.port);
});
