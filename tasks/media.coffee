import Path from "path"
import shell from "./shell"

processVideo = (path, name, t = "00:00:00.00") ->

  input = path
  output = Path.join __dirname, "..", "src", "media", name

  commands = [

    # MP4 conversion
    # pass 1: generate meta for use in pass 2
    "ffmpeg -hide_banner -y -i #{input}
            -an -vcodec h264 -b:v 800k -preset veryslow
            -movflags +faststart -pass 1 -f mp4 /dev/null"


    # pass 2: do conversion using pass 1 metadata
    "ffmpeg -hide_banner -y -i #{input}
            -an -vcodec h264 -b:v 800k -preset veryslow
            -movflags +faststart -pass 2 #{output}.mp4"

    # WebM conversion
    # pass 1
    "ffmpeg -hide_banner -y -i #{input}
            -an -c:v libvpx-vp9 -b:v 800k -preset veryslow
            -movflags +faststart -pass 1 -f webm /dev/null"
    # pass 2
    "ffmpeg -hide_banner -y -i #{input}
            -an -c:v libvpx-vp9 -b:v 800k -preset veryslow
            -movflags +faststart -pass 2 #{output}.webm"

    # create JPG thumbnail
    "ffmpeg -hide_banner -y -i #{input}
            -ss #{t} -vframes 1 #{output}.png"

  ]

  for command in commands
    console.log command
    await shell command

export {processVideo}
