// --- Configuration Parameters ---
const SVG_WIDTH = 1000;
const SVG_HEIGHT = 1000;
const NUM_PATHS = 1000;

const BASE_ANGLE = 45;
const ANGLE_VARIATION = 20;

const KAPPA = 0.552284749831;

/**
 * Converts ellipse radii into an SVG path data string.
 * @param {number} rx - The x-radius of the ellipse.
 * @param {number} ry - The y-radius of the ellipse.
 * @returns {string} The 'd' attribute for an SVG path.
 */
function ellipseToBezierPath(rx, ry) {
  const ox = rx * KAPPA;
  const oy = ry * KAPPA;

  return `M 0 ${-ry} C ${ox} ${-ry}, ${rx} ${-oy}, ${rx} 0 C ${rx} ${oy}, ${ox} ${ry}, 0 ${ry} C ${-ox} ${ry}, ${-rx} ${oy}, ${-rx} 0 C ${-rx} ${-oy}, ${-ox} ${-ry}, 0 ${-ry} Z`;
}

/**
 * NEW: Calculates the matrix transform string for a given position and angle.
 * @param {object} d - The data object containing x, y, and angle.
 * @returns {string} The formatted matrix transform string.
 */
function getMatrixTransform(d) {
  // Convert angle from degrees to radians for JS trig functions
  const angleRad = d.angle * (Math.PI / 180);

  const cos = Math.cos(angleRad);
  const sin = Math.sin(angleRad);
  const tx = d.x;
  const ty = d.y;

  // Matrix components: matrix(a, b, c, d, e, f)
  const a = cos;
  const b = sin;
  const c = -sin;
  const d_val = cos; // Renamed to avoid conflict with data object 'd'
  const e = tx;
  const f = ty;

  return `matrix(${a} ${b} ${c} ${d_val} ${e} ${f})`;
}

// --- Main Script ---

const svg = d3
  .select("#svg-container")
  .append("svg")
  .attr("width", SVG_WIDTH)
  .attr("height", SVG_HEIGHT)
  .attr("xmlns", "http://www.w3.org/2000/svg");

// 1. Generate the data for each ellipse shape
const pathsData = [];
for (let i = 0; i < NUM_PATHS; i++) {
  pathsData.push({
    x: Math.random() * SVG_WIDTH,
    y: Math.random() * SVG_HEIGHT,
    rx: 2 + Math.random() * 10,
    ry: 0.5 + Math.random() * 2,
    angle: BASE_ANGLE + (Math.random() - 0.5) * ANGLE_VARIATION,
    opacity: 0.6 + Math.random() * 0.4,
  });
}

// 2. Bind the data and create the <path> elements
svg
  .selectAll("path")
  .data(pathsData)
  .enter()
  .append("path")
  .attr("d", (d) => ellipseToBezierPath(d.rx, d.ry))
  .attr("fill", "royalblue")
  .attr("opacity", (d) => d.opacity)
  // MODIFIED: Use the new function to set the transform attribute
  .attr("transform", (d) => getMatrixTransform(d));
