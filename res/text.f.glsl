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
#version 300 es
precision mediump float;
precision mediump int;
in vec2 TexCoords;
flat in vec3 fg;
flat in vec4 bg;
uniform int backgroundPass;

layout(location = 0) out vec4 color;

uniform sampler2D mask;

void main()
{
    if (backgroundPass != 0) {
        if (bg.a == 0.0)
            discard;

        color = vec4(bg.rgb, 1.0);
    } else {
        vec3 textColor = texture(mask, TexCoords).rgb;
        color = vec4(fg, textColor.r);
    }
}
