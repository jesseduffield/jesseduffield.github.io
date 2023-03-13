---
layout: post
title: The Audacity (Uncorrupting an Audacity Project)
---

_TLDR: The official [un-corruption guide](https://support.audacityteam.org/troubleshooting/recovering-corrupted-projects) doesn't support OSX, so I got around that with docker, and the guide's advice did not work for me: I had to export the project's individual sample files and concatenate them back together_

I recorded a podcast with my AI Researcher friend Matt Farrugia yesterday: a podcast that went for a whopping 3.5 hours! So you can imagine my face when Audacity told me my data was corrupted.

Here's how I went about fixing it:

(Note: I had made barely any edits to my project before it got corrupted: if you have made many edits and you want to recover those edits, this guide may not help you).

First off I took a deep breath.
Then I took a look a Audacity's corrupted projects [troubleshooting guide](https://support.audacityteam.org/troubleshooting/recovering-corrupted-projects).

This guide tells you to install `audacity-project-tools` from the [github repo](https://github.com/audacity/audacity-project-tools). Unfortunately, only linux and windows are supported and I'm on a mac. But I know a thing or two about [docker](https://github.com/jesseduffield/lazydocker) so I spun up a ubuntu docker container with my directory mounted:

```sh
# --rm means remove the container once we're done with it
# -ti means open in an interactive terminal
# -v means mount the host directory to the container directory. My .aup3 file lives in 'recover-audacity/'
docker run --rm -ti -v /Users/me/Documents/recover-audacity/:/app ubuntu bash
```

Once inside, I confirmed my broken project file had been mounted properly:
```sh
cd /app
ls
> broken.aup3
```

Then I installed some dependencies and installed the latest release of `audacity-project-tools`

```sh
apt-get update
apt-get install curl unzip
# note: you should check the github releases page to see if there's a newer version
curl -SOL https://github.com/audacity/audacity-project-tools/releases/download/v1.0.2/audacity-project-tools-1.0.2-Linux.zip
unzip audacity-project-tools-1.0.2-Linux.zip
# allow us to run `audacity-project-tools` as an executable file
cp audacity-project-tools-1.0.2-Linux/bin/audacity-project-tools /usr/local/bin/
cp audacity-project-tools-1.0.2-Linux/bin/sqlite3 /usr/local/bin/
```

I followed the guide's instructions by seeing if either of the following two commands produced a repaired .aup3 file
```sh
audacity-project-tools -drop_autosave broken.aup3
audacity-project-tools -recover_db -recover_project broken.aup3
```

But neither worked: in both cases Audacity simply opened to a blank project with no audio.

I also tried the following commands to produce a .wav output from the project:

```sh
audacity-project-tools -extract_as_stereo_track broken.aup3
audacity-project-tools -extract_as_mono_track broken.aup3
```

But both produced short wav files with a bunch of jumbled up samples.

At this point I accepted defeat and sat in the sun for a while contemplating life and processing my emotions.

Then I tried one last thing:

```sh
audacity-project-tools -extract_sample_blocks broken.aup3
```

This produced a nested directory structure of 5-second wav files:

```sh
sampleblocks/
  000/
    00/
      1.wav
      2.wav
      ...
      32.wav
    01/
      33.wav
      34.wav
      ...
      64.wav
    ...
    31/
      ...
      1024.wav
  001/
    00/
      1025.wav
      1026.wav
      ...
    ...
  002/
  ...
```

When clicking from one file to the next, it appeared arbitrarily jumbled, but then I realised that odd filenames corresponded to one of the two microphones, and even filenames corresponded to the other microphone. So if I played every second file one after the other, I heard coherent, contiguous chunks of audio.

So the next step was to concatenate these files together. I flattened the file structure by copying each file into a new directory (with help from ChatGPT of course):

```sh
# This was run from back in my OSX terminal now that I no longer needed a linux-specific program
source_dir="/Users/me/Documents/recover-audacity/broken_data/sampleblocks"
dest_dir="/Users/me/Documents/recover-audacity/broken_data/sampleblocks_flat"

# Use find to recursively find all files in the source directory
find "$source_dir" -type f -print0 |
while IFS= read -r -d $'\0' file; do
  # Use mv to move each file to the destination directory
  mv "$file" "$dest_dir"
done
```

Now in the `sampleblocks_flat` directory we had:
```sh
1.wav
2.wav
3.wav
...
4000.wav
4001.wav
...
```

I did a quick sanity check that there were no missing in-between files by copying the list of filenames into sublime text, sorting, and verifying the files matched up with the line numbers (an admittedly lazy approach but it gets the job done). I noticed at the end of the file list there were a couple of files that didn't belong: I suspected these were created as part of a small edit I made. I didn't care about edits, I just wanted my original recording back, so I deleted those extra files. I don't know how these files are typically arranged, but if all you did is record the audio, and you didn't actually edit anything, then you probably won't need to do much cleanup before you can concatenate the files together.

I noticed that some files were not 1.1mb like the rest

```sh
ls -lh
total 29M
-rw-r--r-- 1 root root 1.1M Mar 13 01:16 1.wav
-rw-r--r-- 1 root root  74K Mar 13 01:16 10.wav
-rw-r--r-- 1 root root 1.1M Mar 13 01:16 11.wav
-rw-r--r-- 1 root root  75K Mar 13 01:16 12.wav
-rw-r--r-- 1 root root 522K Mar 13 01:16 13.wav
-rw-r--r-- 1 root root 1.1M Mar 13 01:16 14.wav
-rw-r--r-- 1 root root 729K Mar 13 01:16 15.wav
-rw-r--r-- 1 root root 1.1M Mar 13 01:16 16.wav
-rw-r--r-- 1 root root 1.1M Mar 13 01:16 17.wav
-rw-r--r-- 1 root root 1.1M Mar 13 01:16 18.wav
-rw-r--r-- 1 root root 1.1M Mar 13 01:16 19.wav
-rw-r--r-- 1 root root 1.1M Mar 13 01:16 2.wav
-rw-r--r-- 1 root root 682K Mar 13 01:16 20.wav
-rw-r--r-- 1 root root 682K Mar 13 01:16 21.wav
-rw-r--r-- 1 root root 1.1M Mar 13 01:16 22.wav
```

I suspect these files were behind the corruption. Luckily for me, they were all situated at the very start of the recording, before anybody started talking, so I removed all files from the start up to and including the last under-sized file. I then ensured that the first two files corresponded to the same slice of audio.

I asked chatGPT how to concatenate these files and it recommended I used `sox` so I ran:

```sh
brew install sox
cd /Users/me/Documents/recover-audacity/broken_data/sampleblocks_flat
# even files to into audio track A
sox $(ls . | grep -E '^.*[13579]\.wav$' | sort -n) audio_track_A.wav
# odd files to into audio track B
sox $(ls . | grep -E '^.*[02468]\.wav$' | sort -n) audio_track_B.wav
```

Then I imported those audio tracks into ableton and it was all there, un-corrupted!

If you find yourself in the same situation that I did, I hope the above steps can help you uncorrupt your audacity project!
