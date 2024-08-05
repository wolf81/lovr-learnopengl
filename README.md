# LÖVR Learn Open GL

This repository will contain LÖVR versions of the [Learn Open GL](https://learnopengl.com/) tutorials.

In short I want to explain the modifications made to the LÖVR shader code, as compared to the original shader code.

## Color Conversion

- When sending colors to a shader, it's important to call `lovr.math.gammaToLinear()`, otherwise colors will look very different.



