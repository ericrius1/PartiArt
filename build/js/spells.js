(function() {
  var Spells;

  FW.Spells = Spells = (function() {
    function Spells() {
      var _this = this;
      this.spells = [];
      this.activeSpellIndex = 0;
      this.spells.push(new FW.Wand());
      this.spells.push(new FW.Fire());
      this.spells.push(new FW.Bubbles());
      $('body')[0].on('mousedown', function(event) {
        return _this.spells[_this.activeSpellIndex].castSpell();
      });
      $('body')[0].on('mouseup', function() {
        return _this.spells[_this.activeSpellIndex].endSpell();
      });
    }

    Spells.prototype.update = function() {
      var spell, _i, _len, _ref, _results;
      _ref = this.spells;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        spell = _ref[_i];
        _results.push(spell.update());
      }
      return _results;
    };

    Spells.prototype.nextSpell = function() {
      var element, elements, _i, _len, _results;
      this.spells[this.activeSpellIndex].endSpell();
      this.activeSpellIndex++;
      if (this.activeSpellIndex === this.spells.length) {
        this.activeSpellIndex = 0;
      }
      elements = document.getElementsByClassName('spell');
      _results = [];
      for (_i = 0, _len = elements.length; _i < _len; _i++) {
        element = elements[_i];
        if (element.id === this.spells[this.activeSpellIndex].name) {
          _results.push(element.className = 'spell show-class');
        } else {
          _results.push(element.className = 'spell hide-class');
        }
      }
      return _results;
    };

    return Spells;

  })();

}).call(this);
