# waifu2x-converter-docker
A Docker Automated Build Repository for 
[`WL-Amigo/waifu2x-converter-cpp`](https://github.com/WL-Amigo/waifu2x-converter-cpp)

Forked from 
[`siomiz/waifu2x-converter-cpp`](https://github.com/siomiz/waifu2x-converter-cpp)

# Intended Usage

Specifically written to handle a single `.png` file 
(on host, without somehow moving it inside a container) at a run.

The entrypoint handles I/O (stdin/out) redirection so do not NOT specify `-i` nor `-o` 
(for waifu2x-converter, not to be confused with `-i` for docker run, which is required).

### Example: 
```
docker run --rm -i siomiz/waifu2x -m noise_scale < in.png > out.png
```

If you forgot to feed `< in.png`, press Ctrl+D to terminate (will result in a container core dump).

# General Usage

The executable is at `/opt/w2x/waifu2x-converter`.
You can directly run it as:

```
docker run --rm -it --entrypoint=/opt/w2x/waifu2x-converter siomiz/waifu2x --help
```

# Command Line Arguments

- `-j <integer>`,  `--jobs <integer>`: Number of threads launching at the same time
- `--model_dir <string>`: Path to custom model directory (don't append last `/` )
- `--scale_ratio <double>`: Custom scale ratio
- `--noise_level <1|2>`: Noise reduction level
- `-m <noise|scale|noise_scale>`, `--mode <noise|scale|noise_scale>`: Image processing mode
