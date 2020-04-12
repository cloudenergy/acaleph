describe('Object', () => {
  describe('deep equal', () => {
    it('should compare objects', () => {
      ({a: 1}).should.be.deep.equal({a: 1})
    });
  });
});