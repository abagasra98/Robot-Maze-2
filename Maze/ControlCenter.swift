//
//  ControlCenter.swift
//  Maze
//
//  Created by Abdul Bagasra on 02/14/2016
//  Copyright © 2016 TAIMS, Inc. All rights reserved.
//
import UIKit

class ControlCenter {

    var mazeController: MazeController!

    func moveComplexRobot(robot: ComplexRobotObject) {
        
        let isWall = self.isWall(robot, direction: robot.direction)
        let wallInfo = checkWalls(robot)
        
        let isThreeWayJunction = wallInfo.numberOfWalls == 1
        let isTwoWayPath = wallInfo.numberOfWalls == 2
        let isDeadEnd = wallInfo.numberOfWalls == 3

        if (isTwoWayPath && !isWall) {
            robot.move()
        } else if (isTwoWayPath && isWall) {
            turnTowardClearPath(robot, wallInfo: wallInfo)
        } else if (isDeadEnd && !isWall) {
            robot.move()
        } else if (isDeadEnd && isWall) {
            randomlyRotateRightOrLeft(robot)
        } else if (isThreeWayJunction && !isWall) {
            continueStraightOrRotate(robot, wallInfo: wallInfo)
        } else if (isThreeWayJunction && isWall) {
            randomlyRotateRightOrLeft(robot)
        }

    }
    
    func isWall(robot: ComplexRobotObject, direction: MazeDirection) -> Bool {
        let cell = mazeController.currentCell(robot)
        var isWall: Bool = false
        
        switch direction {
        case .Up:
            if cell.top {
                isWall = true
            }
        case .Down:
            if cell.bottom {
                isWall = true
            }
        case .Left:
            if cell.left {
                isWall = true
            }
        case .Right:
            if cell.right {
                isWall = true
            }
        }

        return isWall
    }

    func checkWalls(robot:ComplexRobotObject) -> (up: Bool, right: Bool, down: Bool, left: Bool, numberOfWalls: Int) {
        var numWalls = 0
        let cell = mazeController.currentCell(robot)
        
        let topWall = cell.top
        if topWall {
            numWalls++
        }
        
        let rightWall = cell.right
        if rightWall {
            numWalls++
        }

        let bottomWall = cell.bottom
        if bottomWall {
            numWalls++
        }
        
        let leftWall = cell.left
        if leftWall {
            numWalls++
        }
        
        return (topWall, rightWall, bottomWall, leftWall, numWalls)
    }
    
    func randomlyRotateRightOrLeft(robot: ComplexRobotObject) {
        let randomNumber = arc4random() % 2
        
        if (randomNumber == 0) {
            robot.rotateRight()
        } else {
            robot.rotateLeft()
        }
        
    }
    
    func continueStraightOrRotate(robot: ComplexRobotObject, wallInfo: (up: Bool, right: Bool, down: Bool, left: Bool, numberOfWalls: Int) ) {
        let randomNumber = arc4random() % 2
        
        if (randomNumber == 0) {
            robot.move()
        } else {
            turnTowardClearPath(robot, wallInfo: wallInfo)
        }

    }
    
    func turnTowardClearPath(robot: ComplexRobotObject, wallInfo: (up: Bool, right: Bool, down: Bool, left: Bool, numberOfWalls: Int)) {

        if robot.direction == .Left && wallInfo.down {
            robot.rotateRight()
        } else if robot.direction == .Up && wallInfo.left {
            robot.rotateRight()
        } else if robot.direction == .Right && wallInfo.up {
            robot.rotateRight()
        } else if robot.direction == .Down && wallInfo.right {
            robot.rotateRight()
        } else if robot.direction == .Left && wallInfo.up {
            robot.rotateLeft()
        } else if robot.direction == .Up && wallInfo.right {
            robot.rotateLeft()
        } else if robot.direction == .Right && wallInfo.down {
            robot.rotateLeft()
        } else if robot.direction == .Down && wallInfo.left {
            robot.rotateLeft()
        } else {
            randomlyRotateRightOrLeft(robot)
        }
    }
    
    func previousMoveIsFinished(robot: ComplexRobotObject) {
            self.moveComplexRobot(robot)
    }
    
}