# dockerized-verification-setup
This is a dockerized tool chain for running verilog DV customized for the sky130A-based projects.

# How To Build Locally?

Run the following command:

```bash
sh build-docker.sh
```

# How To download?

Run the following command:

```bash
docker pull efabless/dv_setup:latest
```

# How to Run?

Run the follwing commands:

```bash
export PDK_PATH= <The full pdk path, i.e.: /home/aag/test_pdk/sky130A or based on the preference>
export TARGET_PATH= <The target project path>
docker run -it -v $CARAVEL_PATH:$CARAVEL_PATH -v $PDK_PATH:$PDK_PATH -e CARAVEL_PATH=$CARAVEL_PATH -e PDK_PATH=$PDK_PATH  -u $(id -u $USER):$(id -g $USER) efabless/dv_setup:latest
```
