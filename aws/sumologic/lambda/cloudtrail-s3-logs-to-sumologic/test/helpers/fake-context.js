module.exports = function(assertions, done) {
  return {
    succeed: function() {
      assertions();
      done();
    },
    fail: function (err) {
      assertions();
      done(err);
    }
  };
};
