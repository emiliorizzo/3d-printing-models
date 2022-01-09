const jscad = require('@jscad/modeling')
const { cylinder } = jscad.primitives
const { subtract } = jscad.booleans


// Here we define the user editable parameters:
const getParameterDefinitions = () => {
  return [
    { name: 'dowelDiameter', caption: 'Dowel diameter', type: 'number', initial: 10, min: 5, max: 50, step: 0.1 },
    { name: 'dowelHeight', caption: 'Dowel Height', type: 'int', initial: 5, min: 1, max: 30, step: 1 },
    { name: 'holeDiameter', caption: 'Hole Diameter', type: 'int', initial: 4, min: 1, max: 30, step: 1 },
    { name: 'segments', caption: 'Segments', type: 'int', initial: 128, min: 8, max: 128, step: 1 }

  ]
}

const main = (params) => {
  const { dowelHeight: height, holeDiameter, dowelDiameter, segments } = params
  const radius = dowelDiameter / 2
  const dowel = cylinder({ radius, height, segments })
  const hole = cylinder({ radius: holeDiameter / 2, height, segments: 64 })
  return subtract(dowel, hole)
}


module.exports = { main, getParameterDefinitions }