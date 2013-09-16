;(function(){

function css(el, obj) {

/**
 * Properties to ignore appending "px".
 */

var ignore = {
  columnCount: true,
  fillOpacity: true,
  fontWeight: true,
  lineHeight: true,
  opacity: true,
  orphans: true,
  widows: true,
  zIndex: true,
  zoom: true
};

/**
 * Set `el` css values.
 *
 * @param {Element} el
 * @param {Object} obj
 * @return {Element}
 * @api public
 */

  for (var key in obj) {
    var val = obj[key];
    if ('number' == typeof val && !ignore[key]) val += 'px';
    el.style[key] = val;
  }
  return el;
}

/**
 * Retina-enable the given `canvas`.
 *
 * @param {Canvas} canvas
 * @return {Canvas}
 * @api public
 */

function autoscaleCanvas(canvas) {
  var ctx = canvas.getContext('2d');
  var ratio = window.devicePixelRatio || 1;
  if (1 != ratio) {
    canvas.style.width = canvas.width + 'px';
    canvas.style.height = canvas.height + 'px';
    canvas.width *= ratio;
    canvas.height *= ratio;
    ctx.scale(ratio, ratio);
  }
  return canvas;
};

function raf() {

/**
 * Expose `requestAnimationFrame()`.
 */

var _raf = window.requestAnimationFrame
  || window.webkitRequestAnimationFrame
  || window.mozRequestAnimationFrame
  || window.oRequestAnimationFrame
  || window.msRequestAnimationFrame
  || fallback;

/**
 * Fallback implementation.
 */

var prev = new Date().getTime();
function fallback(fn) {
  var curr = new Date().getTime();
  var ms = Math.max(0, 16 - (curr - prev));
  setTimeout(fn, ms);
  prev = curr;
}

/**
 * Cancel.
 */

var cancel = window.cancelAnimationFrame
  || window.webkitCancelAnimationFrame
  || window.mozCancelAnimationFrame
  || window.oCancelAnimationFrame
  || window.msCancelAnimationFrame;

this.cancel = function(id){
  cancel.call(window, id);
};

_raf.apply(this, arguments);
}


/**
 * Module dependencies.
 */

var autoscale = autoscaleCanvas;

/**
 * Expose `Spinner`.
 */

// module.exports = Spinner;

/**
 * Initialize a new `Spinner`.
 */

function Spinner() {
  var self = this;
  this.percent = 0;
  this.el = document.createElement('canvas');
  this.ctx = this.el.getContext('2d');
  this.size(50);
  this.fontSize(8);
  this.speed(60);
  this.font('helvetica, arial, sans-serif');
  this.stopped = false;

  (function animate() {
    if (self.stopped) return;
    raf(animate);
    self.percent = (self.percent + self._speed / 36) % 100;
    self.draw(self.ctx);
  })();
}

/**
 * Stop the animation.
 *
 * @api public
 */

Spinner.prototype.stop = function(){
  this.stopped = true;
};

/**
 * Set spinner size to `n`.
 *
 * @param {Number} n
 * @return {Spinner}
 * @api public
 */

Spinner.prototype.size = function(n){
  if(n == this._size_p) return;
  this.el.width = n;
  this.el.height = n;
  autoscale(this.el);
  this._size_p = n;
  return this;
};

/**
 * Set text to `str`.
 *
 * @param {String} str
 * @return {Spinner}
 * @api public
 */

Spinner.prototype.text = function(str){
  this._text = str;
  return this;
};

/**
 * Set font size to `n`.
 *
 * @param {Number} n
 * @return {Spinner}
 * @api public
 */

Spinner.prototype.fontSize = function(n){
  this._fontSize = n;
  return this;
};

/**
 * Set font `family`.
 *
 * @param {String} family
 * @return {Spinner}
 * @api public
 */

Spinner.prototype.font = function(family){
  this._font = family;
  return this;
};

/**
 * Set speed to `n` rpm.
 *
 * @param {Number} n
 * @return {Spinner}
 * @api public
 */

Spinner.prototype.speed = function(n) {
  this._speed = n;
  return this;
};

/**
 * Make the spinner light colored.
 *
 * @return {Spinner}
 * @api public
 */

Spinner.prototype.light = function(){
  this._light = true;
  return this;
};

/**
 * Draw on `ctx`.
 *
 * @param {CanvasRenderingContext2d} ctx
 * @return {Spinner}
 * @api private
 */

Spinner.prototype.draw = function(ctx){
  var percent = Math.min(this.percent, 100)
    , ratio = window.devicePixelRatio || 1
    , size = this.el.width / ratio
    , half = size / 2
    , x = half
    , y = half
    , rad = half - 1
    , fontSize = this._fontSize
    , light = this._light;

  ctx.font = fontSize + 'px ' + this._font;

  var angle = Math.PI * 2 * (percent / 100);
  ctx.clearRect(0, 0, size, size);

  // outer circle
  var grad = ctx.createLinearGradient(
    half + Math.sin(Math.PI * 1.5 - angle) * half,
    half + Math.cos(Math.PI * 1.5 - angle) * half,
    half + Math.sin(Math.PI * 0.5 - angle) * half,
    half + Math.cos(Math.PI * 0.5 - angle) * half
  );

  // color
  if (light) {
    grad.addColorStop(0, 'rgba(255, 255, 255, 0)');
    grad.addColorStop(1, 'rgba(255, 255, 255, 1)');
  } else {
    grad.addColorStop(0, 'rgba(0, 0, 0, 0)');
    grad.addColorStop(1, 'rgba(0, 0, 0, 1)');
  }

  ctx.strokeStyle = grad;
  ctx.beginPath();
  ctx.arc(x, y, rad, angle - Math.PI, angle, false);
  ctx.stroke();

  // inner circle
  ctx.strokeStyle = light ? 'rgba(255, 255, 255, .4)' : '#eee';
  ctx.beginPath();
  ctx.arc(x, y, rad - 1, 0, Math.PI * 2, true);
  ctx.stroke();

  // text
  var text = this._text || ''
    , w = ctx.measureText(text).width;

  if (light) ctx.fillStyle = 'rgba(255, 255, 255, .9)';
  ctx.fillText(
      text
    , x - w / 2 + 1
    , y + fontSize / 2 - 1);

  return this;
}


function spin(el, options) {
/**
 * Module dependencies.
 */


/**
 * Add a spinner to `el`,
 * and adjust size and position
 * based on `el`'s box.
 *
 * Options:
 *
 *    - `delay` milliseconds defaulting to 300
 *    - `size` size defaults to 1/5th the parent dimensions
 *
 * @param {Element} el
 * @param {Object} options
 * @return {Spinner}
 * @api public
 */

  if (!el) throw new Error('element required');

  var appended = false;
  var spin = new Spinner(el);
  options = options || {};
  var ms = options.delay || 300;

  // update size and position
  spin.update = function(){
    var w = el.offsetWidth;
    var h = el.offsetHeight;

    // size
    var s = options.size || Math.min(w - 5, h - 5);
    spin.size(s);

    // position
    css(spin.el, {
      position: 'absolute',
      top: h / 2 - s / 2,
      left: w / 2 - s / 2
    });
  }

  spin.update();

  // remove
  spin.remove = function(){
    if (appended) el.removeChild(spin.el);
    spin.stop();
    clearTimeout(timer);
  };

  // append
  var timer = setTimeout(function(){
    appended = true;
    el.appendChild(spin.el);
  }, ms);

  return spin;
}

// Module dependencies.
var win = window,
    doc = window.document,
    defaults = {
        'line': 'vertical',
        'theme': 'dark',
        'text': '',
        'className': ''
    };

function customizeOptions(options) {
    var prop;
    for (prop in defaults) {
        if (!options.hasOwnProperty(prop)) {
            options[prop] = defaults[prop];
        }
    }
    return options;
}

/**
 * Create a new instance of Flipload.
 * @constructor
 * @param {HTMLElement} el A given HTML element to create an instance of Flipload.
 * @param {Object} [options] Options to customize an instance.
 * @param {String} [options.className] Add a custom className to the reverse element to add custom CSS styles.
 * @param {String} [options.line] Rotate around horizontal or vertical line. By default is vertical line.
 * @param {String} [options.theme] Select what spinner theme you want to use: light or dark. By default is dark.
 * @param {String} [options.text] Add some text to the spinner.
 * @returns {flipload} Returns a new instance of Flipload.
 */
function Flipload(el, options) {

    if (el === undefined) {
        throw new Error('"Flipload(el, [options])": It must receive an element.');
    }

    this.initialize(el, options);

    return this;
}

/**
 * Initialize a new instance of Flipload.
 * @memberof! Flipload.prototype
 * @function
 * @param {HTMLElement} el A given HTML element to create an instance of Flipload.
 * @param {Object} [options] Options to customize an instance.
 * @returns {flipload} Returns the instance of Flipload.
 */
Flipload.prototype.initialize = function (el, options) {

    this.el = el;

    // Customize options
    this.options = customizeOptions(options || {});

    this.loading = false;

    this._enabled = true;

    this.el.className += ' flipload-front flipload-front-' + this.options.line;

    // Create reverse element
    this._createReverse();

    // Create spinner
    // this._createSpinner();

    // Store the flipload instance
    this.el.flipload = this;

    return this;
};

/**
 * Creates the reverse element.
 * @memberof! Flipload.prototype
 * @function
 * @private
 * @returns {flipload} Returns the instance of Flipload.
 */
Flipload.prototype._createReverse = function () {

    this.reverse = doc.createElement('div');
    pic = doc.createElement('div');
    pic.className = 'loader';
    this.reverse.appendChild(pic);

    this.reverse.style.position = win.getComputedStyle(this.el, "").getPropertyValue('position') === 'fixed' ? 'fixed' : 'absolute';;

    this.reverse.className = 'flipload-reverse flipload-reverse-' + this.options.line + ' ' + this.options.className;

    this._updateReverseSize();

    this._updateReverseOffset();

    this.el.parentNode.insertBefore(this.reverse, this.el);

    return this;
};

/**
 * Updates/refresh the size of the reverse element.
 * @memberof! Flipload.prototype
 * @function
 * @private
 * @returns {flipload} Returns the instance of Flipload.
 */
Flipload.prototype._updateReverseSize = function () {

    this.reverse.style.width = this.el.offsetWidth + 'px';
    this.reverse.style.height = this.el.offsetHeight + 'px';

    return this;
};

/**
 * Updates/refresh the offset of the reverse element.
 * @memberof! Flipload.prototype
 * @function
 * @private
 * @returns {flipload} Returns the instance of Flipload.
 */
Flipload.prototype._updateReverseOffset = function () {

    this.reverse.style.top = this.el.offsetTop + 'px';
    this.reverse.style.left = this.el.offsetLeft + 'px';

    return this;
};

/**
 * Creates spinner element.
 * @memberof! Flipload.prototype
 * @function
 * @private
 * @returns {flipload} Returns the instance of Flipload.
 */
Flipload.prototype._createSpinner = function () {

    this.spinner = spin(this.reverse);

    // Custom Options
    if (this.options.theme === 'light') {
        this.spinner.light();
    }

    this.spinner.text(this.options.text);

    return this;
};

/**
 * Update size and positon values of the reverse element and spinner.
 * @memberof! Flipload.prototype
 * @function
 * @returns {flipload} Returns the instance of Flipload.
 */
Flipload.prototype.update = function () {

    if (!this._enabled) {
        return this;
    }

    // Update reverse
    this._updateReverseSize();
    this._updateReverseOffset();

    // Update spinner
    // this.spinner.update();

    return this;
};

/**
 * Flips and shows the spinner.
 * @memberof! Flipload.prototype
 * @function
 * @returns {flipload} Returns the instance of Flipload.
 */
Flipload.prototype.load = function () {

    if (this.loading || !this._enabled) {
        return this;
    }

    this.loading = true;

    var _this = this;
    (function continuous_update() {
        if(!_this.loading) return;
        _this.update();
        raf(continuous_update);
    })();

    this.el.className += ' flipload-loading';
    this.reverse.className += ' flipload-loading';

    return this;
};

/**
 * Flips and hides the spinner.
 * @memberof! Flipload.prototype
 * @function
 * @returns {flipload} Returns the instance of Flipload.
 */
Flipload.prototype.done = function () {

    if (!this.loading || !this._enabled) {
        return this;
    }

    this.loading = false;

    this.el.className = this.el.className.replace(/flipload-loading/, '');
    this.reverse.className = this.reverse.className.replace(/flipload-loading/, '');

    return this;
};

/**
 * Toggle the spinner element.
 * @memberof! Flipload.prototype
 * @function
 * @returns {flipload} Returns the instance of Flipload.
 */
Flipload.prototype.toggle = function () {

    if (this.loading) {
        return this.done();
    }

    this.load();

    return this;
};

/**
 * Enables an instance of Flipload.
 * @memberof! Flipload.prototype
 * @function
 * @returns {flipload} Returns the instance of Flipload.
 */
Flipload.prototype.enable = function () {
    this._enabled = true;

    return this;
};

/**
 * Disables an instance of Flipload.
 * @memberof! Flipload.prototype
 * @function
 * @returns {flipload} Returns the instance of Flipload.
 */
Flipload.prototype.disable = function () {
    this._enabled = false;

    return this;
};

/**
 * Destroys an instance of Flipload.
 * @memberof! Flipload.prototype
 * @function
 */
Flipload.prototype.destroy = function () {

    // Remove classNames
    this.el.className = this.el.className.replace(/flipload-front(-(vertical|horizontal))?/g, '');

    // Remove spinner
    this.spinner.remove();

    // Remove the reverse element
    this.el.parentNode.removeChild(this.reverse);

    // Remove the flipload instance
    this.el.flipload = undefined;
}

window.Flipload = Flipload;
})();
