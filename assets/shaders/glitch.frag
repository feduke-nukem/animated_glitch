#version 460 core 

#include <flutter/runtime_effect.glsl>

const float MAX_CHANCE = 100.0;
const float MAX_ITERATIONS = 10.0;

uniform float uTime;
uniform vec2 uResolution;
uniform float uDistortionLevel; //0 - 1 glitch level
uniform float uColorChannelLevel; //0 - 1 glitch level
uniform float uSpeed; //0 - 1 speed
uniform float uChance; //0 - 100 percent chance of glitch
uniform float uShowDistortions; //0 - 1
uniform float uShowColorChannels; //0 - 1
uniform float uShiftColorChannelsY; //0 - 1
uniform float uShiftColorChannelsX; //0 - 1
uniform float uGlitchAmount;
uniform sampler2D uChannel0;

out vec4 fragColor;

//2D (returns 0 - 1)
float random2d(vec2 n) { 
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float randomRange (in vec2 seed, in float min, in float max) {
		return min + random2d(seed) * (max - min);
}

// return 1 if v inside 1d range
float insideRange(float v, float bottom, float top) {
   return step(bottom, v) - step(top, v);
}
   
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    float time = floor(uTime * uSpeed * 60.0);
    vec2 uv = fragCoord.xy / uResolution.xy;
    
    // Copy original color
    vec3 outColor = texture(uChannel0, uv).rgb;
    float randomChance = random2d(vec2(time, 9545.0));
    bool shouldGlitch = randomChance <= uChance / MAX_CHANCE; 
    
    if (shouldGlitch) {

        // Randomly offset slices horizontally
        if(uShowDistortions == 1.0){
            float maxOffset = uDistortionLevel;

            for (float i = 0.0; i < MAX_ITERATIONS; i += 1.0) {
                if (i >= uGlitchAmount){break;}
                float sliceY = random2d(vec2(time , 2345.0 + float(i)));
                float sliceH = random2d(vec2(time , 9035.0 + float(i))) * 0.25;
                float hOffset = randomRange(vec2(time , 9625.0 + float(i)), -maxOffset, maxOffset);
                vec2 uvOff = uv;
                uvOff.x += hOffset;
                if (insideRange(uv.y, sliceY, fract(sliceY + sliceH)) == 1.0){
                    outColor = texture(uChannel0, uvOff).rgb;
                }
            }
        }

        // Do slight offset on one entire channel
        if(uShowColorChannels == 1.0){
            float maxColOffset = uColorChannelLevel;
            float rnd = random2d(vec2(time, 9545.0));
            float xRange = (uShiftColorChannelsX == 1.0) ? randomRange(vec2(time , 9545.0), -maxColOffset, maxColOffset) : 0.0;
            float yRange = (uShiftColorChannelsY == 1.0) ? randomRange(vec2(time , 7205.0), -maxColOffset, maxColOffset) : 0.0;
            vec2 colOffset = vec2(xRange, yRange);
            if (rnd < 0.33){
                outColor.r = texture(uChannel0, uv + colOffset).r;
            } else if (rnd < 0.66){
                outColor.g = texture(uChannel0, uv + colOffset).g;
            } else {
                outColor.b = texture(uChannel0, uv + colOffset).b;  
            }
        }
    }
  
    fragColor = vec4(outColor, 1.0);
 
}

void main(){
    vec2 pos = FlutterFragCoord().xy;
    mainImage(fragColor, pos);
}