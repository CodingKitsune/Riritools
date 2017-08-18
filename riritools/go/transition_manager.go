components {
  id: "transition_script"
  component: "/riritools/script/transition_manager.script"
  position {
    x: 0.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
embedded_components {
  id: "transition"
  type: "sprite"
  data: "tile_set: \"/riritools/atlas/dummy.atlas\"\n"
  "default_animation: \"dummy\"\n"
  "material: \"/riritools/material/transition.material\"\n"
  "blend_mode: BLEND_MODE_ALPHA\n"
  ""
  position {
    x: 0.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
