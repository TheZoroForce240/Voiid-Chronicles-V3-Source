function createPost()
    initShader('water', 'WaterEffect')
    setActorShader('water', 'water')
    setShaderProperty('water', 'speed', 0.25)
    setShaderProperty('water', 'strength', 18)
end