// @point Closures, optional params
Function createLogFunction({String prefix = 'general'})
{
  return (String message) { print('[${prefix}]: ${message}'); };
}

void main()
{
  var warn = createLogFunction(prefix: 'warning');
  var error = createLogFunction(prefix: 'error');
  var info = createLogFunction(prefix: 'info');
  
  Figure figure = Figure();
  assert(figure.dimension == 0);
  info('assert(figure.dimension == 0)');
  
  figure.dimension = 3;    
  assert(figure.dimension == 3);
  info('assert(figure.dimension == 3)');
}

// @point Mixins
mixin JsonDescription
{
  Map<String, String> _jsonDictionary = {};

  void setProperty(String key, String value)
  {
    _jsonDictionary[key] = value;
  }

  String getProperty(String key)
  {
    // @point Syntactic sugar
    return _jsonDictionary[key] ?? '';
  }
  
}

class Figure with JsonDescription
{
  int get dimension => int.parse(getProperty('dimension'));

  set dimension(int dimension)
  {
    setProperty('dimension', dimension.toString());
  }
  
}
