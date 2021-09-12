import 'dart:ui';
import 'dart:core';
import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';

// ----------------------------------------------------------------------------
// Helper interface
// ----------------------------------------------------------------------------

// @consider Neither generics nor mixins are able to abstract to Vector2 class
class Vector2i
{
  int x = 0;
  int y = 0;

  // @point Named constructor
  // @point Initialization lists
  Vector2i.origin(): x = 0, y = 0 { }

  // @point In-place constructor
  Vector2i(this.x, this.y);

  // @point Fat arrow notation
  Vector2i operator +(Vector2i vec) => Vector2i(x + vec.x, y + vec.y);
  Vector2i operator -(Vector2i vec) => Vector2i(x - vec.x, y - vec.y);
  bool operator ==(Object vec) => vec is Vector2i && vec.x == x && vec.y == y;

  Vector2i copy()
  {
    return Vector2i(x, y);
  }  
}

class Vector2d
{
  double x = 0;
  double y = 0;

  Vector2d.origin(): x = 0, y = 0 { }
  Vector2d(this.x, this.y);

  Vector2d operator +(Vector2d vec) => Vector2d(x + vec.x, y + vec.y);
  Vector2d operator -(Vector2d vec) => Vector2d(x - vec.x, y - vec.y);
  bool operator ==(Object vec) => vec is Vector2d && vec.x == x && vec.y == y;

  Vector2d copy()
  {
    return Vector2d(x, y);
  }  
}

// @point Enumerations
enum Direction
{
  Left,
  Top,
  Right,
  Bottom
}

bool areOppositeDirections(Direction directionA, Direction directionB)
{
  return (directionA.index - directionB.index).abs() % 2 == 0;
}

Vector2i directionToVector(Direction direction)
{
  switch(direction)
  {
    case Direction.Left: return Vector2i(-1, 0); break;
    case Direction.Top: return Vector2i(0, -1); break;
    case Direction.Right: return Vector2i(1, 0); break;
    case Direction.Bottom: return Vector2i(0, 1); break;        
  }
}

Vector2d getScreenSize()
{
  return Vector2d(
    window.physicalSize.width / window.devicePixelRatio,
    window.physicalSize.height / window.devicePixelRatio,
  );
}

// ----------------------------------------------------------------------------
// Abstractions
// ----------------------------------------------------------------------------

// @point "Interface" declaration
abstract class Renderable
{
  Vector2i position = Vector2i.origin();
  Color getRepresentation();
}

abstract class Playable
{
  void processTapInput(Vector2d pos);
}

// ----------------------------------------------------------------------------
// Main code
// ----------------------------------------------------------------------------

enum PowerupType
{
  Apple,
  Orange,
  Berry,
  
  COUNT
}

class _PowerupProperties
{
  int bonusSize;  
  Color color;

  _PowerupProperties(this.bonusSize, this.color);
}

class Powerup implements Renderable
{

  // @point Dictionary, private fields
  static final _propertiesTable =
  {
    PowerupType.Apple: _PowerupProperties(1, Colors.red),
    PowerupType.Orange: _PowerupProperties(3, Colors.orange),
    PowerupType.Berry: _PowerupProperties(5, Colors.blue),
  };
  
  _PowerupProperties _properties;
  Vector2i position;  
  
  Powerup(this._properties, this.position);

  // @point Factory constructor
  factory Powerup.createInstance(PowerupType type, Vector2i position)
  {
    switch(type)
    {
      // @point Forcing to non-nullable type
      case PowerupType.Apple: return Powerup(_propertiesTable[type]!, position); break;
      case PowerupType.Orange: return Powerup(_propertiesTable[type]!, position); break;
      case PowerupType.Berry: return Powerup(_propertiesTable[type]!, position); break;

      // @point Assertions
      case PowerupType.COUNT: assert(false, "COUNT is not a real powerup type!"); break;
    }
    
    return Powerup(_propertiesTable[PowerupType.Apple]!, Vector2i.origin());
  }
  
  Color getRepresentation()
  {
    return _properties.color;
  }

  // @point Fancy getter/setter syntax
  int get bonusSize
  {
    return _properties.bonusSize;
  }
}

class SnakePart implements Renderable
{
  Vector2i position;
  
  SnakePart(this.position);
  
  Color getRepresentation()
  {
    return Colors.green;
  }
}


class Snake implements Playable
{
  // @point Lists
  List<SnakePart> parts = [];
  Direction currentDirection = Direction.Right;
  Direction nextDirection = Direction.Right;

  Snake()
  {
    SnakePart head = SnakePart(Vector2i.origin());
    parts.add(head);
    nextDirection = currentDirection = Direction.Right;
  }

  void placeHeadOnMap(GameMap gameMap)
  {
    gameMap.setRenderable(head, head.position);
  }
  
  void processTapInput(Vector2d pos)
  {
    print('${pos.x}, ${pos.y}');
    
    Vector2d vecToCenter = Vector2d(
      0.5 - pos.x,
      0.5 - pos.y,
    );

    Vector2d absVecToCenter = Vector2d(
      vecToCenter.x.abs(),
      vecToCenter.y.abs(),
    );

    Direction potentialDirection = nextDirection;
    if(absVecToCenter.x > absVecToCenter.y)
    {
      potentialDirection = vecToCenter.x >= 0 ? Direction.Left : Direction.Right;
    }
    else
    {
      potentialDirection = vecToCenter.y >= 0 ? Direction.Top : Direction.Bottom;
    }

    if(!areOppositeDirections(currentDirection, potentialDirection))
    {
      nextDirection = potentialDirection;
    }
  }
  
  void move(GameMap gameMap)
  {
    Vector2i newPosition = getHeadNextPosition(gameMap);
    for(SnakePart part in parts)
    {
      Vector2i prevPosition = part.position;

      gameMap.setRenderable(gameMap.getRenderable(prevPosition), newPosition); 
      gameMap.setRenderable(newPosition == prevPosition ? part : null, prevPosition);
      
      part.position = newPosition;
      newPosition = prevPosition;
    }

    currentDirection = nextDirection;
  }

  void passPowerup(Powerup powerup)
  {
    Vector2i tailPosition = tail.position;
    
    for(var i = 0; i < powerup.bonusSize; i++)
    {
      parts.add(SnakePart(tailPosition));
    }
  }

  SnakePart get head
  {
    return parts.first;
  }

  SnakePart get tail
  {
    return parts.last;
  }

  Vector2i getHeadNextPosition(GameMap gameMap)
  {
    return gameMap.wrapPosition(head.position + directionToVector(nextDirection));    
  }

  bool positionIsOccupied(Vector2i position)
  {
    return parts.any((SnakePart part) => part.position == position);
  }
}

class GameMap
{
  // @point Static variables
  static const double tableWidth            = 500;
  static const double tableHeight           = 500;
  static const double minPowerupSpawnTimeMs = 2000;
  static const double powerupSpawnChance    = 0.5;
  static const int    maxPowerupsCount      = 3;

  bool gameOver                             = false;
  double elapsedTimeSinceStartMs            = 0;
  double elapsedTimeSincePowerupSpawnMs     = 0;

  Random RNG                                = Random();  
  Snake snake                               = Snake();
  List<Powerup> powerups                    = <Powerup>[];

  // @point Nullable type
  List<List<Renderable?>> renderables       = <List<Renderable?>>[];

  GameMap(int size)
  {
    for(var i = 0; i < size; i++)
    {
      renderables.add(<Renderable?>[]);
      renderables[i].length = size;
    }

    snake.placeHeadOnMap(this);
  }
  
  void processTapInput(TapDownDetails details)
  {
    final screenSize = getScreenSize();
    final globalTapPosition = details.globalPosition;
    final localTapPosition = Vector2d(
      globalTapPosition.dx - screenSize.x * 0.5 + tableWidth * 0.5,
      globalTapPosition.dy - screenSize.y * 0.5 + tableHeight * 0.5,
    );
    
    snake.processTapInput(Vector2d(
        localTapPosition.x / (tableWidth as double),
        localTapPosition.y / (tableHeight as double),
      ),
    );
  }
  
  void update(double delta)
  {
    elapsedTimeSincePowerupSpawnMs += delta;
    elapsedTimeSinceStartMs += delta;
    
    if(!gameOver)
    {
      _processCollisions();
      _generatePowerups();
      
      snake.move(this);
    }
  }
  
  Widget render()
  {
    if(gameOver)
    {
      return Center(child: Text("Game over!"));
    }
    else
    {
      final mapSize = renderables.length;
      final cellWidth = tableWidth / mapSize;
      final cellHeight = tableHeight / mapSize;
      
      var tableRows = <TableRow>[];
      for(var row in renderables)
      {
        var tableRowWidgets = <Widget>[];
        for(Renderable? renderable in row)
        {
          tableRowWidgets.add(
            TableCell(
              child: Container(
                color: (renderable != null ? renderable.getRepresentation() : Colors.white),
                height: cellWidth,
                width: cellHeight,
              ),
            ),
          );
        }
        
        tableRows.add(
          TableRow(
            children: tableRowWidgets,
          ),
        );
      }
      
      return Center(child: Container(
          child: Table(
            border: TableBorder.all(),
            children: tableRows,
          ),
          width: tableWidth,
          height: tableHeight
        )
      );
    }
  }
  
  Vector2i wrapPosition(Vector2i position)
  {
    final mapSize = renderables.length;

    return Vector2i(
      (position.x + mapSize) % mapSize,
      (position.y + mapSize) % mapSize,      
    );
  }

  Renderable? getRenderable(Vector2i position)
  {
    assert(position.x >= 0 && position.x < renderables.length &&
      position.y >= 0 && position.y < renderables.length);
    
    return renderables[position.y][position.x];
  }

  void setRenderable(Renderable? renderable, Vector2i position)
  {
    assert(position.x >= 0 && position.x < renderables.length &&
      position.y >= 0 && position.y < renderables.length);
    
    renderables[position.y][position.x] = renderable;
  }
  
  void _processCollisions()
  {
    Vector2i headNextPosition = snake.getHeadNextPosition(this);    
    // Process self-collision
    if(snake.positionIsOccupied(headNextPosition))
    {
      gameOver = true;
      return;
    }
    
    // Process powerups collision
    for(Powerup powerup in powerups)
    {
      if(powerup.position == headNextPosition)
      {
        snake.passPowerup(powerup);
        powerups.remove(powerup);
        break;
      }
    }
  }

  void _generatePowerups()
  {
    if(elapsedTimeSincePowerupSpawnMs > minPowerupSpawnTimeMs)
    {
      if(powerups.length < maxPowerupsCount && RNG.nextDouble() <= powerupSpawnChance)
      {
        final mapSize = renderables.length;
        Vector2i newPowerupPosition = snake.head.position.copy();
        
        while(getRenderable(newPowerupPosition) != null)
        {
          newPowerupPosition.x = RNG.nextInt(mapSize - 1);
          newPowerupPosition.y = RNG.nextInt(mapSize - 1);
        }

        Powerup newPowerup = Powerup.createInstance(
          PowerupType.values[RNG.nextInt(PowerupType.COUNT.index)],
          newPowerupPosition,
        );
        
        setRenderable(newPowerup, newPowerupPosition);
        powerups.add(newPowerup);
        
        elapsedTimeSincePowerupSpawnMs = 0;
      }
    }
  }
}

class SnakeGame extends StatefulWidget
{
  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame>
{
  static const int frameTimeMs = 100;
  GameMap gameMap = GameMap(15);

  _SnakeGameState()
  {
    // @point Passing function
    new Timer.periodic(Duration(milliseconds: frameTimeMs), handleTimerTimeout);
  }
  
  void handleTimerTimeout(Timer timer)
  {
    gameMap.update(frameTimeMs as double);

    // @point Passing lambda function
    setState((){});
  }

  void handleTapDown(TapDownDetails details)
  {
    gameMap.processTapInput(details);
  }
  
  @override
  Widget build(BuildContext context)
  {
    return new GestureDetector(
      onTapDown: handleTapDown,
      child: Container(
        child: gameMap.render(),
      ),
    );
  }
}
