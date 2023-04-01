# sweetstackhq.com (ARCHIVE)

Sweetstack is a restaurant-tech project I worked on in the first half of 2022. It was supposed to be a QR-code food & beverage ordering system for restaurants that leveraged the new (at the time) App Clip and Instant App mobile-app technologies to achieve a superior user experience.

This repo is the marketing website that I designed, developed and maintained. I put it on GitHub mainly for archival purposes, and also as a reference implementation to others.

The different parts of the repo:

- The [static folder](https://github.com/pietrorea/sweetstackhq.com/tree/master/static/www) contains the bulk of the HTML, JS and CSS that make up the marketing site. These files are all hand-written by me and do not require a build system of any sort.
- There's a [tiny Express server](https://github.com/pietrorea/sweetstackhq.com/tree/master/backend) just to send an email whenever someone would fill out the contact form. I also included the [scripts](https://github.com/pietrorea/sweetstackhq.com/tree/master/backend/scripts) I used to deploy and restart the Express server.
- Both the marketing site it's backend were served directly from an AWS Lightsail VM using nginx (no CDN!). This [setup script](https://github.com/pietrorea/sweetstackhq.com/blob/master/scripts/intial-setup.sh) fully configures the VM for this task.
