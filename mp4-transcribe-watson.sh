#!/bin/bash
#
# mp4-transcribe-watson
# warrenf 2018-04-03 Replaced awscli commands with curl on Watson APIs

# Script configuration
      version="$(basename "$0") v2018-04-03"
    timestamp=$(date -u +"%Y%m%dT%H%M%SZ")

# Watson speech-to-text API configuration
job_name="mp4-transcribe-watson-$timestamp"
media_format="mp3"
watson_username=""
watson_password=""
service_uri="https://stream.watsonplatform.net/speech-to-text/api/v1/recognize"

# Help usage text
usage="$(basename "$0") [-h] [-i input_video_file]

where:
    -h   show this help text
    -i   the name of the video file to be transcribed, in MP4 format"

# Initialize the names of the input parameters
     video_file=""
     audio_file=""
transcript_file=""

while getopts ":hi:o:" option; do
    case "$option" in
        h) echo "$usage"
           exit 0
           ;;
        i) video_file=$OPTARG
           ;;
        :) printf "missing argument for -%s\n" "$OPTARG" >&2
           echo "$usage" >&2
           exit 1
           ;;
       \?) printf "unknown option: -%s\n" "$OPTARG" >&2
           echo "$usage" >&2
           exit 1
           ;;
    esac
done
shift $((OPTIND-1))

# Check for the Watson API username and password
while [ "$watson_username" == "" ]; do
    read -p "Enter your Watson API username: " watson_username
done
while [ "$watson_password" == "" ]; do
    read -p "Enter your Watson API password: " watson_password
done

# Keep prompting until the user enters valid parameters
while [ ! -f "$video_file" ]; do
    if [ "$video_file" != "" ]; then
        printf "\nerror: cannot find video file %s\n" "$video_file"
    fi
    read -p "Enter the video file name (e.g. video.mp4): " video_file
done

# Set filenames for the audio and transcription files
 base_file=${video_file%.*}
audio_file=$base_file.mp3
  job_name=$job_name-$base_file

echo $version
echo "Timestamp:                            $timestamp"
echo "Source video file:                    $video_file"

# Extract and convert audio from video source
ffmpeg -hide_banner -loglevel panic -i $video_file -vn -acodec $media_format $audio_file

if [ -f "$audio_file" ]; then
    printf "Extracted and converted audio track:  %s\n" "$audio_file"
else
    echo "error: cannot generate audio file"
    exit -1
fi

# Create transcribe JSON request
printf "Start transcription job: \n\n"

# Start transcription job
curl -X POST -u $watson_username:$watson_password \
    --header "Content-Type: audio/$media_format" \
    --data-binary @$audio_file \
    "$service_uri" \
    > $job_name-response.json

cat $job_name-response.json
