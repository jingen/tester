describe('filter', function(){
  beforeEach(module('oa'));

  describe('reverse', function(){
    it('should reverse a string', inject(function(reverseFilter){
      expect(reverseFilter('ABCD')).toEqual('DCBA');
    }));
  });
});