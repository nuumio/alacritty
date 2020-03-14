// Copyright 2016 Joe Wilm, The Alacritty Project Contributors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
#version 100
precision mediump float;
precision lowp int;
// Cell properties
attribute vec2 gridCoords;

// vertex properties
attribute vec2 extra;

// glyph properties
attribute vec4 glyph;

// uv mapping
attribute vec4 uv;

// text fg color
attribute vec3 textColor;

// Background color
attribute vec4 backgroundColor;

varying float colored;
varying vec2 TexCoords;
varying vec3 fg;
varying vec4 bg;

// Terminal properties
uniform vec2 cellDim;
uniform vec4 projection;

uniform int backgroundPass;


void main()
{
    vec2 projectionOffset = projection.xy;
    vec2 projectionScale = projection.zw;

    // Compute vertex corner position
    vec2 position;
    position.x = (extra.x == 0. || extra.x == 1.) ? 1. : 0.;
    position.y = (extra.x == 0. || extra.x == 3.) ? 0. : 1.;
    colored = extra.y;

    // Position of cell from top-left
    vec2 cellPosition = cellDim * gridCoords;

    if (backgroundPass != 0) {
        vec2 finalPosition = cellPosition + cellDim * position;
        gl_Position = vec4(projectionOffset + projectionScale * finalPosition, 0.0, 1.0);

        TexCoords = vec2(0, 0);
    } else {
        vec2 glyphSize = glyph.zw;
        vec2 glyphOffset = glyph.xy;
        glyphOffset.y = cellDim.y - glyphOffset.y;

        vec2 finalPosition = cellPosition + glyphSize * position + glyphOffset;
        gl_Position = vec4(projectionOffset + projectionScale * finalPosition, 0.0, 1.0);

        vec2 uvOffset = uv.xy;
        vec2 uvSize = uv.zw;
        TexCoords = uvOffset + position * uvSize;
    }

    bg = vec4(backgroundColor.rgb / 255.0, backgroundColor.a);
    fg = textColor / vec3(255.0, 255.0, 255.0);
}
