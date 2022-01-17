const jscad = require('@jscad/modeling')
const { cylinder } = jscad.primitives
const { subtract, union } = jscad.booleans
const { translate } = jscad.transforms


// Here we define the user editable parameters:
const getParameterDefinitions = () => {
  return [
    { name: 'knobDiameter', caption: 'Knob diameter', type: 'number', initial: 35, min: 5, max: 70, step: 0.1 },
    { name: 'knobHeight', caption: 'Knob Height', type: 'number', initial: 8, min: 1, max: 50, step: 0.1 },
    { name: 'knobSides', caption: 'Knob sides', type: 'int', initial: 11, min: 3, max: 90, step: 1 },
    { name: 'nutDiameter', caption: 'Nut Diameter', type: 'number', initial: 11.8, min: 2, max: 20, step: 0.1 },
    { name: 'nutHeight', caption: 'Nut height', type: 'number', initial: 5, min: 2, max: 40, step: 0.1 },
    { name: 'holeDiameter', caption: 'Hole Diameter', type: 'number', initial: 6.2, min: 2, max: 50, step: 0.1 },
    { name: 'light', caption: 'Light', type: 'number', initial: 0.1, min: 0, max: 1, step: 0.1 }

  ]
}



const main = ({ knobDiameter, knobHeight, knobSides, nutDiameter, nutHeight, holeDiameter, light }) => {
  const getRadius = d => (d / 2) + light
  if (knobHeight < nutHeight) knobHeight = nutHeight
  if (knobDiameter < nutDiameter) knobDiameter = nutDiameter
  const knob = cylinder({ radius: knobDiameter / 2, height: knobHeight, segments: knobSides })
  const hole = cylinder({ radius: getRadius(holeDiameter), height: knobHeight, segments: 360 })
  const nut = cylinder({ radius: getRadius(nutDiameter), height: nutHeight, segments: 6 })
  // knob.translate([10, 0, 0])

  return subtract(subtract(knob, translate([0, 0, (knobHeight / 2) - nutHeight / 2], nut)), hole)
}


module.exports = { main, getParameterDefinitions }