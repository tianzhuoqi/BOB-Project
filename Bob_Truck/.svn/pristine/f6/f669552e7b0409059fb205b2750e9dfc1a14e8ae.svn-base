local data = {
    suns={
        color={ --颜色资源配置
            {resource="ModelFBX/Solarsystem/Suns/Color/purple"},
            {resource="ModelFBX/Solarsystem/Suns/Color/blue"},
            {resource="ModelFBX/Solarsystem/Suns/Color/white"},
            {resource="ModelFBX/Solarsystem/Suns/Color/faintyellow"},
            {resource="ModelFBX/Solarsystem/Suns/Color/yellow"},
            {resource="ModelFBX/Solarsystem/Suns/Color/jacinth"},
            {resource="ModelFBX/Solarsystem/Suns/Color/red"}
        },
        type={ --恒星主体资源配置
            {resource="ModelFBX/Solarsystem/Suns/Sun_red_gamma",scale=6,crid="01"},
            {resource="ModelFBX/Solarsystem/Suns/Sun_red_gamma",scale=8,crid="01"},
            {resource="ModelFBX/Solarsystem/Suns/Sun_red_gamma",scale=6,crid="02"},
            {resource="ModelFBX/Solarsystem/Suns/Sun_red_gamma",scale=8,crid="02"},
            {resource="ModelFBX/Solarsystem/Suns/Sun_red_gamma",scale=6,crid="03"},
            {resource="ModelFBX/Solarsystem/Suns/Sun_red_gamma",scale=8,crid="03"}
            --[[
            {resource="ModelFBX/Solarsystem/Suns/Type/dwarfStar",scale=6,crid="01"},
            {resource="ModelFBX/Solarsystem/Suns/Type/secondSuperstar",scale=8,crid="01"},
            {resource="ModelFBX/Solarsystem/Suns/Type/superstar",scale=6,crid="02"},
            {resource="ModelFBX/Solarsystem/Suns/Type/brightStar",scale=8,crid="02"},
            {resource="ModelFBX/Solarsystem/Suns/Type/superGiantStar",scale=6,crid="03"},
            {resource="ModelFBX/Solarsystem/Suns/Type/superGiantPlanet",scale=8,crid="03"}
            ]]
        }
    },
    planets={
        prefab={
            "ModelFBX/Solarsystem/Planets/Prefabs/P1.prefab",
            "ModelFBX/Solarsystem/Planets/Prefabs/P2.prefab",
            "ModelFBX/Solarsystem/Planets/Prefabs/P3.prefab",
            "ModelFBX/Solarsystem/Planets/Prefabs/P4.prefab",
            "ModelFBX/Solarsystem/Planets/Prefabs/P5.prefab",
            "ModelFBX/Solarsystem/Planets/Prefabs/P6.prefab",
            "ModelFBX/Solarsystem/Planets/Prefabs/P7.prefab",
            "ModelFBX/Solarsystem/Planets/Prefabs/P8.prefab",
            "ModelFBX/Solarsystem/Planets/Prefabs/P9.prefab",
            "ModelFBX/Solarsystem/Planets/Prefabs/P10.prefab",
            "ModelFBX/Solarsystem/Planets/Prefabs/P11.prefab",
            "ModelFBX/Solarsystem/Planets/Prefabs/P12.prefab",
            "ModelFBX/Solarsystem/Planets/Prefabs/P13.prefab",
            "ModelFBX/Solarsystem/Planets/Prefabs/P14.prefab",
        },
        mask={--行星美术资源配置
            {
                --此类行星外观具有的主要数值资源id
                mainResIds = {
                    210000001,210000002,
                    210000003,210000004,
                },
                resource = {
                    mainType = "ModelFBX/Solarsystem/Planets/Prefabs/Neptune.prefab", --主体
                    properties = {
                        _OceanMask = {
                            type = "texture",
                            method = "RandomTable",
                            table = {
                                "ModelFBX/Solarsystem/Planets/Textures/mask_02.png",
                                "ModelFBX/Solarsystem/Planets/Textures/mask_03.png"
                            }
                        },
                        _OceanMask2 = {
                            type = "texture",
                            method = "RandomTable",
                            table = {
                                "ModelFBX/Solarsystem/Planets/Textures/mask_02.png",
                                "ModelFBX/Solarsystem/Planets/Textures/mask_03.png"
                            }
                        },
                        _OceanMask2U = {
                            type = "float",
                            method = "RandomFloat",
                            methodP = 48,
                            method2 = nil
                        },
                        _OceanMask2V = {
                            type = "float",
                            method = "RandomFloat",
                            methodP = 24,
                            method2 = nil
                        },
                        _TintColor = {
                            type = "color",
                            method = "RandomTable",
                            table = {
                                -------r,g,b
                                {255,255,255}
                            }
                        },
                        _WaterColor = {
                            type = "color",
                            method = "RandomTable",
                            table = {
                                -------r,g,b
                                {242,241,205},
                                {218,205,242},
                                {122,202,234},
                                {148,135,108}
                            }
                        },
                        _VegetationColor = {
                            type = "color",
                            method = "RandomTable",
                            table = {
                                -------r,g,b
                                {233,175,103},
                                {233,143,103},
                                {103,233,152}
                            }
                        },
                    }
                }
            },
            {
                mainResIds = {
                    210000001,210000002,
                    210000003,210000004,
                },
                resource = {
                    mainType = "ModelFBX/Solarsystem/Planets/Prefabs/Earth.prefab",
                    properties = {
                        _OceanMask = {
                            type = "texture",
                            method = "RandomTable",
                            table = {
                                "ModelFBX/Solarsystem/Planets/Textures/mask_01.png",
                                "ModelFBX/Solarsystem/Planets/Textures/mask_04.png",
                                "ModelFBX/Solarsystem/Planets/Textures/mask_06.png",
                            }
                        },
                        _OceanMask2 = {
                            type = "texture",
                            method = "RandomTable",
                            table = {
                                "ModelFBX/Solarsystem/Planets/Textures/mask_01.png",
                                "ModelFBX/Solarsystem/Planets/Textures/mask_04.png",
                                "ModelFBX/Solarsystem/Planets/Textures/mask_06.png",
                            }
                        },
                        _OceanMask2U = {
                            type = "float",
                            method = "RandomFloat",
                            methodP = 24,
                            method2 = nil
                        },
                        _TintColor = {
                            type = "color",
                            method = "RandomTable",
                            table = {
                                -------r,g,b
                                {255,255,255},
                                {255,255,255},
                                {255,255,255},
                            }
                        },
                        --[[_WaterColor = {
                            type = "color",
                            method = "ResidTable",
                            table = {
                                -------r,g,b
                                [2] = {62,132,161},
                                [8] = {8,134,186},
                                [15] = {18,118,218},
                            }
                        },]]
                        _WaterColor = {
                            type = "color",
                            method = "RandomTable",
                            table = {
                                -------r,g,b
                                {62,132,161},
                                {8,134,186},
                                {18,118,218},
                            }
                        },
                        _VegetationColor = {
                            type = "color",
                            method = "RandomTable",
                            table = {
                                -------r,g,b
                                {66,218,46},
                                {46,154,218},
                                {166,218,46},
                            }
                        },
                        _CloudsMap = {
                            type = "texture",
                            method = "RandomTable",
                            table = {
                                "ModelFBX/Solarsystem/Planets/Textures/clouds_04.png",
                                "ModelFBX/Solarsystem/Planets/Textures/clouds_05.png",
                                "ModelFBX/Solarsystem/Planets/Textures/clouds_06.png",
                                "ModelFBX/Solarsystem/Planets/Textures/clouds_07.png",
                            }
                        },
                    }
                }
            },
            {
                mainResIds = {
                   210000001,210000002,
                    210000003,210000004,
                },--此类行星外观具有的主要数值资源id
                resource = {
                    mainType = "ModelFBX/Solarsystem/Planets/Prefabs/Rock.prefab",
                    properties = {
                        _OceanMask = {
                            type = "texture",
                            method = "RandomTable",
                            table = {
                                "ModelFBX/Solarsystem/Planets/Textures/mask_01.png",
                                "ModelFBX/Solarsystem/Planets/Textures/mask_04.png",
                                "ModelFBX/Solarsystem/Planets/Textures/mask_05.png",
                                "ModelFBX/Solarsystem/Planets/Textures/mask_06.png",
                            }
                        },
                        _OceanMask2 = {
                            type = "texture",
                            method = "RandomTable",
                            table = {
                                "ModelFBX/Solarsystem/Planets/Textures/mask_01.png",
                                "ModelFBX/Solarsystem/Planets/Textures/mask_04.png",
                                "ModelFBX/Solarsystem/Planets/Textures/mask_05.png",
                                "ModelFBX/Solarsystem/Planets/Textures/mask_06.png",
                            }
                        },
                        _OceanMask2U = {
                            type = "float",
                            method = "RandomFloat",
                            methodP = 32,
                            method2 = nil
                        },
                        _TintColor = {
                            type = "color",
                            method = "RandomTable",
                            table = {
                                -------r,g,b
                                {255,255,255},
                            }
                        },
                        _WaterColor = {
                            type = "color",
                            method = "RandomTable",
                            table = {
                                -------r,g,b
                                {176,175,174},
                                {218,218,218},
                                {202,229,227},
                            }
                        },
                        _VegetationColor = {
                            type = "color",
                            method = "RandomTable",
                            table = {
                                -------r,g,b
                                {105,77,73},
                                {84,84,84},
                                {3,116,102}
                            }
                        },
                    }
                }
            },
            {
                mainResIds = {
                    210000001,210000002,
                    210000003,210000004,

                },--此类行星外观具有的主要数值资源id
                resource = {
                    mainType = "ModelFBX/Solarsystem/Planets/Prefabs/Lava.prefab",
                    properties = {
                        _OceanMask = {
                            type = "texture",
                            method = "RandomTable",
                            table = {
                                "ModelFBX/Solarsystem/Planets/Textures/mask_01.png",
                                "ModelFBX/Solarsystem/Planets/Textures/mask_04.png",
                                "ModelFBX/Solarsystem/Planets/Textures/mask_05.png",
                                "ModelFBX/Solarsystem/Planets/Textures/mask_06.png",
                            }
                        },
                        _OceanMask2 = {
                            type = "texture",
                            method = "RandomTable",
                            table = {
                                "ModelFBX/Solarsystem/Planets/Textures/mask_01.png",
                                "ModelFBX/Solarsystem/Planets/Textures/mask_04.png",
                                "ModelFBX/Solarsystem/Planets/Textures/mask_05.png",
                                "ModelFBX/Solarsystem/Planets/Textures/mask_06.png",
                            }
                        },
                        _OceanMask2U = {
                            type = "float",
                            method = "RandomFloat",
                            methodP = 32,
                            method2 = nil
                        },
                        _TintColor = {
                            type = "color",
                            method = "RandomTable",
                            table = {
                                -------r,g,b
                                {255,255,255},
                            }
                        },
                        _WaterColor = {
                            type = "color",
                            method = "RandomTable",
                            table = {
                                -------r,g,b
                                {193,52,0},
                                {173,0,0},
                                {210,179,162},
                            }
                        },
                        _VegetationColor = {
                            type = "color",
                            method = "RandomTable",
                            table = {
                                -------r,g,b
                                {255,111,0},
                                {255,180,45},
                                {255,58,0}
                            }
                        },
                    }
                }
            },
        },
    },
    

}

return data