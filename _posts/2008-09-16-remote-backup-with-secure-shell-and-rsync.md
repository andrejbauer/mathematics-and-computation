---
id: 96
title: Remote Backup with Secure Shell and Rsync
date: 2008-09-16T14:15:50+02:00
author: Andrej Bauer
layout: post
guid: http://math.andrej.com/?p=96
permalink: /2008/09/16/remote-backup-with-secure-shell-and-rsync/
categories:
  - Software
---
Back in 2000 [John Langford](http://hunch.net/~jl/) of the [Machine Learning (Theory) blog](http://hunch.net/) and I wrote a backup script which I am still using today. A number of other people have found it useful so I decided to release it under an open source license. The script is easy to use under Linux. I am told it also backs up Windows with a bit of tweaking.  
<!--more-->

The impatient readers may go ahead and immediately [download the backup script](http://math.andrej.com/wp-content/uploads/2008/09/backup-0.1.zip). Read the enclosed file INSTALL.txt for installation instructions. You will need [perl](http://www.perl.org/), [ssh](http://www.openssh.com/) and [rsync](http://samba.anu.edu.au/rsync/), all standard parts of most Linux distributions. Here I will explain the idea behind the script.

### How it works

Suppose we have a directory _d_ on machine A which we want to backup to a remote machine B. For example, _d_ could be the entire file system or your home directory. If we already have an outdated copy of _d_ stored on machine B, then rsync is the perfect tool for the task. It detects the differences between the original and the copy, and intelligently propagates them from machine A to machine B.

However, we typically want to keep several copies of the backup (daily, weekly, monthly, yearly) and not just one. The procedure for making a new backup is then as follows:

  * on machine B make a copy of the latest backup available,
  * use rsync to update the copy with the original on machine A,
  * delete some of the old backups if there are too many.

This idea is fine, except that each backup takes up as much space as the original. Although disk space is very cheap, we would quickly run out of space on machine B. Even more annoying would be the time needed to make a copy of the backup (if you do not believe me, try copying 30GB of data spread accross ten thousand files from one directory to another on the same disk). A little bit of Unix filesystem magic helps solve the problem. Instead of physically copying the latest backup, we copy just the directory structure and [hard link](http://http://en.wikipedia.org/wiki/Hard_link) the files (read the [Wikipedia article on hard links](http://http://en.wikipedia.org/wiki/Hard_link) if you have never heard of them). The [GNU cp command](http://www.gnu.org/software/coreutils/manual/html_node/cp-invocation.html) with the `--link` argument does this very efficiently. This way the latest backup and its copy share all the data. When we run rsync on the copy, it &#8220;unshares&#8221; only those files that have changed. That&#8217;s it.

The net result is a series of backups which share common data. Additionally, if we delete any of the backups, the others remain intact (even though they share data). When the last backup holding a reference to a particular file is deleted, the Unix filesystem removes the data for that file from disk. We have incremental backups where each snapshot behaves exactly like the original.

The backup script does all this for you. It also controls the number of old backups kept, sends you e-mail if a backup fails, allows you to tell rsync which files or file types to ignore, and more.

### Backup in practice

I just backed up my laptop. It took very long, 7 minutes, because I had not backed it up for two weeks and have accumulated many new files. Typically it takes somewhere between 30 seconds for &#8220;empty&#8221; backup and 2 minutes after a day&#8217;s work with lots of downloads and compilation of large chunks of source code. My backup server contains a total of 21 backups of my laptop, which comes up to 29 GB of disk space. The oldest backup is from 2006 and it takes 694 MB, whereas the latest is from one minute ago and takes 12 GB of space.

Other uses of the backup script that I have heard of:

  * I backup our home computer every night over a slow ADSL line whose upload rate is only 256 Mbit/s. Last night it took 40 seconds, but it takes several hours when my wife dumps a camera full of photos into her home directory.
  * A reasearch instutite with more than 700 employees uses the backup script to backup their mail server _every 10 minutes_!
  * At my department we backup the main web server and the e-learning site, which has more than a thousand users and several gigabytes of data. (We also dump the databases and backup the dumps, too.)

### MacOS and Windows

There are certain similarities between the backup script and MacOS [&#8220;Time machine&#8221;](http://www.apple.com/macosx/features/timemachine.html), but I suspect the Time machine actually backs up journals from a [journaling file system](http://en.wikipedia.org/wiki/Journaling_file_system). Anyhow, the backup script should work on MacOS, which is just Unix in disguise.

If you want to backup a Windows machine, you could install perl, ssh and rsync on it. It ought to work in principle (note that only the server needs a file system with hard links). Or you can mount its filesystem on a Linux machine with [Samba](http://us1.samba.org/samba/), and make the backup from the Linux machine. If there is enough interest, I can ask a friend who does this to provide more info.

### Extensions

I am considering an extension that would allow one to do _secondary_ backups on a second server: every time a backup is made on machine B, it would make another copy of the backup on machine C.

An interesting variant of this involves making secondary backups on _untrusted_ machine C as follows. On machine B we create an [encrypted loopback filesystem](http://en.wikipedia.org/wiki/Loop_device) and make backups of machine A in the loopback filesystem. Then we make a secondary backup on machine C by sending it (with rsync) the file containing the loopback system. Because the loopback is encrypted, access to machine C does not reveal the contents of the backup.

### Download

Finally, here is the **download:**

> [backup-0.1.zip](http://math.andrej.com/wp-content/uploads/2008/09/backup-0.1.zip). 

The software is supposed to be stable, contrary to the low version number. It has been working since 2000 without major changes.