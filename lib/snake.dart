import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';

// ----------------------------------------------------------------------------
// Helper interface
// ----------------------------------------------------------------------------

class Vector2i
{
  int x = 0;
  int y = 0;

  Vector2i.origin(): x = 0, y = 0 {}
  Vector2i(this.x, this.y);

  Vector2i operator +(Vector2i vec) => Vector2i(x + vec.x, y + vec.y);
  Vector2i operator -(Vector2i vec) => Vector2i(x - vec.x, y - vec.y);
  bool operator ==(Object vec) => vec is Vector2i && vec.x == x && vec.y == y;

  Vector2i copy()
  {
    return Vector2i(x, y);
  }
}

enum Direction
{
  Left,
  Top,
  Right,
  Bottom
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

// ----------------------------------------------------------------------------
// Abstractions
// ----------------------------------------------------------------------------

abstract class Renderable
{
  Vector2i position = Vector2i.origin();
  Color getRepresentation();
}

abstract class Playable
{
  void processTapInput(TapDownDetails details);
}


// ----------------------------------------------------------------------------
// Main code
// ----------------------------------------------------------------------------

class Powerup implements Renderable
{
  Vector2i position;  
  Color color;
  int bonusSize;
  
  Powerup(this.color, this.bonusSize, this.position);
  
  factory Powerup.createInstance(String powerupName, Vector2i position)
  {
    if(powerupName.toLowerCase() == "apple")
    {
      return Powerup(Colors.red, 1, position);
    }
    else if(powerupName.toLowerCase() == "orange")
    {
      return Powerup(Colors.orange, 2, position);
    }

    assert(false, "Unknown name was given!");
    return Powerup(Colors.black, 0, Vector2i.origin());
  }
  
  Color getRepresentation()
  {
    return color;
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
    gameMap.renderables[parts[0].position.y][parts[0].position.x] = parts[0];
  }
  
  void processTapInput(TapDownDetails details)
  {
    // TODO: determine nextDirection
  }
  
  void move(GameMap gameMap)
  {
    Vector2i newPosition = getHeadNextPosition(gameMap);
    for(SnakePart part in parts)
    {
      Vector2i prevPosition = part.position;

      gameMap.renderables[newPosition.y][newPosition.x] = gameMap.renderables[prevPosition.y][prevPosition.x];
      gameMap.renderables[prevPosition.y][prevPosition.x] = newPosition == prevPosition ? part : null;
      
      part.position = newPosition;
      newPosition = prevPosition;
    }

    currentDirection = nextDirection;
  }

  void passPowerup(Powerup powerup)
  {
    Vector2i tailPosition = getTail().position;
    
    for(var i = 0; i < powerup.bonusSize; i++)
    {
      parts.add(SnakePart(tailPosition));
    }
  }

  SnakePart getHead()
  {
    return parts.first;
  }

  SnakePart getTail()
  {
    return parts.last;
  }

  Vector2i getHeadNextPosition(GameMap gameMap)
  {
    return gameMap.wrapPosition(getHead().position + directionToVector(nextDirection));    
  }

  bool positionIsOccupied(Vector2i position)
  {
    return parts.any((SnakePart part) => part.position == position);
  }
}

class GameMap
{
  static const double tableWidth = 500;
  static const double tableHeight = 500;
  static const double minPowerupSpawnTimeMs = 2000;
  static const double powerupSpawnChance = 0.5;
  static const int maxPowerupsCount = 3;

  bool gameOver = false;
  double elapsedTimeSinceStartMs = 0;
  double elapsedTimeSincePowerupSpawnMs = 0;
  Random RNG = Random();
  
  Snake snake = Snake();
  List<Powerup> powerups = <Powerup>[];
  List<List<Renderable?>> renderables = <List<Renderable?>>[];

  GameMap(int size)
  {
    for(var i = 0; i < size; i++)
    {
      renderables.add(<Renderable?>[]);
      renderables[i].length = size;
    }

    snake.placeHeadOnMap(this);
  }
  
  void processTapInput(BuildContext context, TapDownDetails details)
  {
    
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
      var cellWidth = tableWidth / mapSize;
      var cellHeight = tableHeight / mapSize;
      
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
        Vector2i newPowerupPosition = snake.getHead().position.copy();
        
        while(renderables[newPowerupPosition.y][newPowerupPosition.x] != null)
        {
          newPowerupPosition.x = RNG.nextInt(mapSize - 1);
          newPowerupPosition.y = RNG.nextInt(mapSize - 1);
        }

        // TODO: Choose
        Powerup newPowerup = Powerup.createInstance("apple", newPowerupPosition);
        renderables[newPowerupPosition.y][newPowerupPosition.x] = newPowerup;
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
  static const int frameTimeMs = 500;
  GameMap gameMap = GameMap(7);

  _SnakeGameState()
  {
    new Timer.periodic(Duration(milliseconds: frameTimeMs), handleTimerTimeout);
  }
  
  void handleTimerTimeout(Timer timer)
  {
    gameMap.update(frameTimeMs as double);
    setState((){});
  }
  
  @override
  Widget build(BuildContext context)
  {
    return gameMap.render();
  }
}
