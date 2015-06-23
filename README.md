[![Build Status](https://travis-ci.org/peterstrapp/hubot-sonarqube.svg?branch=master)](https://travis-ci.org/peterstrapp/hubot-sonarqube)

# hubot-sonarqube

A hubot script that displays stats from SonarQube.

See [`src/sonarqube.coffee`](src/sonarqube.coffee) for full documentation.

## Example useage:
```
sonar set server <server address>
sonar test coverage <project name>
```

## Installation

In hubot project repo, run:

`npm install hubot-sonarqube --save`

Then add **hubot-sonarqube** to your `external-scripts.json`:

```json
[
  "hubot-sonarqube"
]
```

## Sample Interaction

```
user1>> sonar set server 192.168.328.54:8090
hubot>> Sonar server set to: 192.168.328.54:8090
user1>> sonar test coverage my service
hubot>> Unit test coverage for "My Service" is 68%
```
