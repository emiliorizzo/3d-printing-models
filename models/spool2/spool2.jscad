const jscad = require('@jscad/modeling')
const { cylinder } = jscad.primitives
const { subtract, union } = jscad.booleans
const { translate, rotate, center } = jscad.transforms
const { colorize, colorNameToRgb } = jscad.colors

const segments = 360


// Here we define the user editable parameters:
const getParameterDefinitions = () => {
  return [
    { name: 'spoolDiameter', caption: 'Spool diameter', type: 'int', initial: 70, min: 5, max: 200, step: 1 },
    { name: 'spoolHeight', caption: 'Spool Height', type: 'int', initial: 15, min: 5, max: 100, step: 1 },
    { name: 'coreDiameter', caption: 'Core Diameter', type: 'int', initial: 30, min: 5, max: 100, step: 1 },
    { name: 'wall', caption: 'Wall Height', type: 'number', initial: 2.4, min: 0.2, max: 5, step: 0.1 },
    { name: 'light', caption: 'Light', type: 'number', initial: 0.1, min: 0, max: 1, step: 0.1 },
  ]
}


const spoolWheel = (radius, coreRadius, height, holes = 7) => {

  const hR = ((radius - coreRadius) / 2) + coreRadius
  let holeRadius = (hR * 2 * Math.PI) / (holes * 2.5)
  if (holeRadius > hR / 4) holeRadius = hR / 4

  const core = cylinder({ radius: coreRadius, height, segments })
  const h = [...new Array(holes)].map((x, i) => {
    const angle = i * 360 / holes * Math.PI / 180
    return translate([hR * Math.sin(angle), hR * Math.cos(angle), 0], center([false, false, false], cylinder({
      radius: holeRadius, height, segments
    })))
  })
  const spool = subtract(cylinder({ radius, height, segments }), union(h))
  return subtract(spool, core)
}

const spoolCore = (radius, height, wall) => {
  const a = cylinder({ radius, height, segments })
  radius -= wall
  const b = cylinder({ radius, height, segments })
  return subtract(a, b)
}

const main = ({ spoolHeight, spoolDiameter, wall, coreDiameter, light }) => {
  const coreRadius = coreDiameter / 2
  const coreWall = wall * 2
  const wheel = spoolWheel(spoolDiameter / 2, coreRadius, wall)
  const coreB = colorize(colorNameToRgb('green'), spoolCore(coreRadius, wall, coreWall))
  const coreC = translate([0, 0, wall], spoolCore(coreRadius - coreWall / 2 - light, wall * 3, wall))
  const core = colorize(colorNameToRgb('red'), translate([0, 0, spoolHeight / 2], subtract(spoolCore(coreRadius, spoolHeight + wall, coreWall),spoolCore(coreRadius - coreWall / 2, wall * 2, wall))))
  return [union(wheel, core), translate([0, spoolDiameter * 1.1, 0], union(wheel, coreB, coreC))]
  // return [core, coreC]
}

module.exports = { main, getParameterDefinitions }