# mp4-transcribe-watson

## Purpose
Command–line utility to create an IBM Watson Speech to Text transcript from a video file.

## Compatibility
This script has been tested on Mac OS 10.13 (High Sierra) with the following utilities installed. Here are the high-level system configuration steps:

1. Install the [Homebrew package manager](https://brew.sh).
2. Run `brew install ffmpeg`.

## How to install this script
The script requires a subscription to the IBM Watson Speech to Text service.  The Watson API issues you a second set of credentials (username, password) that is *different* from your IBM ID.

1. Sign up for the [IBM Watson speech-to-text](https://www.ibm.com/watson/services/speech-to-text/) API service.
2. Write down the generated `username` and `password` credentials for the Watson service.
3. Create a local clone of this repository.

## How to use this script
1. Copy an MP4 video file into the same directory as this script.
2. Run `./mp4-transcribe-watson.sh -i <video_file_name>`, where `video_file_name` is your source video file.
3. Review the `response.json` file to see the transcription results.

## License
Review the [license](LICENSE) before you clone this repository.
