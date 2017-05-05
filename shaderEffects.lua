function loadShaderEffects()
    DefaultShader = love.graphics.getShader() -- save the default shader, to be used later 

    ShaderEffects = {} -- table contains all made shaders
    -- --------------------------------------------------------------------------------------------------------------------------------------------
            -- ------------------------------------------------------------
            -- shader number 1, gives a box in the middle of the screen and change its color every miliseconds based on sin value
            ShaderEffects[1] = {}
            ShaderEffects[1].theScript = love.graphics.newShader [[
                    uniform number time;
                    uniform vec2 screenRes;
                    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
                    {
                        // when its fragment coordinate is inside the given area, its RGB will be colored based on sin and cos value.
                        if( (screen_coords.y-screenRes.y/2.0) > (-0.2875*screenRes.y) &&
                            (screen_coords.y-screenRes.y/2.0) < (0.2875*screenRes.y) ) {
                            return color * (texture2D(texture,texture_coords)) +
                                vec4(abs(sin(time*3.0)),abs(cos(time*2.0)),abs(cos(time*3.0)),0.0);
                        } else if ((screen_coords.y-screenRes.y/2.0) < -231.0) {
                            // when its fragment coordinate is outside the area, it will be colored normally.
                            return color * texture2D(texture,texture_coords);
                        } else {
                            return vec4(0.16078,0.16078,0.16078,1.0);
                        }
                    }
                ]]
            ShaderEffects[1].theScript:send("screenRes",{love.graphics.getWidth(),love.graphics.getHeight()}) -- sending the parameter to shader code
            ShaderEffects[1].update = function () -- sending the parameter value to shader code, called every frame
                ShaderEffects[CurrentShaderEffect].theScript:send("time",GlobalTimeSpan)
            end
            
            -- ------------------------------------------------------------
            -- shader number 2, hide the area around player's touching position
            ShaderEffects[2] = {}
            ShaderEffects[2].theScript = love.graphics.newShader [[
                uniform number time;
                uniform vec2 pos;
                vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
                {
                    float distanceToPos = length(abs(pixel_coords-pos)); // calculate the distance between player's touching position and fragment's coordinate.
                    float radius_ = (120.0+abs(sin(time*2.0)*20.0));  // the sin calculation added a grow and shrink animation.

                    if( distanceToPos > radius_) { // if the distance from touching position is above 120, it will be turn grey.
                        return vec4(0.16078,0.16078,0.16078,1.0);
                    } else { // otherwise, it will be colored normally.
                        return color * texture2D(texture,texture_coords);
                    }
                }
            ]]
            ShaderEffects[2].update = function () -- sending the parameter value to shader code, called every frame
                ShaderEffects[CurrentShaderEffect].theScript:send("time",GlobalTimeSpan)
            end

            -- ------------------------------------------------------------
            -- shader number 3, gives a glitch effect
            ShaderEffects[3] = {}
            ShaderEffects[3].theScript = love.graphics.newShader [[
                uniform vec2 randomValue;
                vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
                {
                    // it returns the fragment of neighbours and added a random color based on random value given every frame.
                    return color * texture2D(texture,vec2(texture_coords.x+randomValue.x,texture_coords.y+randomValue.y)) *
                        vec4(randomValue.x,randomValue.y,randomValue.x,abs(randomValue.y));
                }
            ]]
            ShaderEffects[3].update = function () -- sending the parameter value of random integer to shader code, called every frame
                local x,y = math.random(-1,1),math.random(-1,1)
                ShaderEffects[CurrentShaderEffect].theScript:send("randomValue",{x,y})
            end

            -- ------------------------------------------------------------
            -- shader number 4, gives another glitch effect
            ShaderEffects[4] = {}
            ShaderEffects[4].theScript = love.graphics.newShader [[
                uniform vec2 randomValue;
                vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
                {
                    if(pixel_coords.y < 70.0) {
                        return color * texture2D(texture,texture_coords); // returns normal color.
                    } else {
                        return color * texture2D(texture,vec2(texture_coords.x+randomValue.x,texture_coords.y+randomValue.y)); // returns the color of neighbours.
                    }
                }
            ]]
            ShaderEffects[4].update = function () -- sending the parameter value of random float to shader code, called every frame
                local x,y = math.random(-0.01,0.01),math.random(-0.01,0.01)
                ShaderEffects[CurrentShaderEffect].theScript:send("randomValue",{x,y})
            end
    -- --------------------------------------------------------------------------------------------------------------------------------------------

    CurrentShaderEffect = 0
    -- -----------------------------------------------------------------
end