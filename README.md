# ic-forum-downloader

Script to download Invision Community forum attachments.

## How it works

Most Invision Community forum sites have attachment files by appending path to the end `/applications/core/interface/file/attachment.php?id=` and incrementing the number on the end.

However, most IC forums also have a setting that prevents this from working in most cases. There are some forums that it does work on.

## Usage

Update the script variables `forumPattern`, `start`, and `end` then run the script in your preferred way, VS Code works well.

The script will download files from `start` to `end` in a relative folder to the script in the name of the forum domain name.

How do you know when you've reached the last attachment? It can be hard to tell but there will be nothing but errors and no more files downloaded in the console output.