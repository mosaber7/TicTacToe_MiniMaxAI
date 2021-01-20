import Foundation
enum piece{
    case X //the X starts the game
    case O
    case E // Empty
    
    var opposite: piece{
        switch self {
        case .X:
            return .O
        case .O:
            return .X
        default:
            return .E
        }
        
        }
    }


struct Board{
    
    typealias Move = Int
    //empty game board has nine empty positions
    let emptyBoard: [piece] = [.E, .E, .E,
                               .E, .E, .E,
                               .E, .E, .E]
    //the board represented in an array of ppieces form
    let position: [piece]
    //definr whose turn (X or O)
    let turn: piece
    //the last move made, to be used in the minimax algorithm
    let lastMove: Move
    
    init(position: [piece] = [.E, .E, .E,
                              .E, .E, .E,
                              .E, .E, .E],
         turn: piece = .X, lastMove: Int = -1){
        self.position = position
        self.turn = turn
        self.lastMove = lastMove
    }
    
    // every time a move is done this func will generate a new board with the new piece added
    func move(_ location: Move) -> Board{
        //make a copy of the old Board
        var tempPosition = position
        // add the new piece to the new board, turn -> is defined in the init
        tempPosition[location] = turn
        
        //call the init to intialize a new Board with the new turn, board positions and the last move
        return Board(position: tempPosition, turn: turn.opposite, lastMove: location)
    }
    
    var validMoves: [Move]{
        var validMovesArr: [Move] = []
        var index = 0
        for piece in position{
            if piece == .E{
                validMovesArr.append(index)
            }
            index += 1
        }
        print(validMovesArr)
        return validMovesArr
    }
     func isWin()-> Bool{
        //tp win a player should have at least three positions, the opnonent at least 2 so NO NEED to check if someone won until this point
        if validMoves.count >= 5 {return false}
       
        else { return
            // all zero wining cases
            position[0] != .E && position[0] == position[1] && position[0] == position[2] ||
            position[0] != .E && position[0] == position[3] && position[0] == position[6] ||
            position[0] != .E && position[0] == position[4] && position[0] == position[8] ||
            position[1] != .E && position[1] == position[4] && position[1] == position[7] ||
            
            position[2] != .E && position[2] == position[5] && position[2] == position[8] ||
            position[2] != .E && position[2] == position[4] && position[2] == position[6] ||
            
            position[3] != .E && position[3] == position[4] && position[3] == position[5] ||
            
            position[6] != .E && position[6] == position[7] && position[6] == position[8] 
        }
    }
    var isDraw: Bool{
        if position.contains(.E){
            return false
        }
        return true
    }

    // go through ever possible move and return the calculted wieght of the move picked, however it doesn't tell us what is the best move
    func minimax(_ board: Board, maxmizing: Bool, player: piece, depth: Int,_ alpha: inout Int,_ beta: inout Int) -> Int{
        
        if depth == 0{ return 0}
        //checks the base conditions whether the move is a win or loose or draw
        if board.isWin() && player == board.turn.opposite{
            return 1}
        else if board.isWin() && player != board.turn.opposite{
            return -1}
        else if board.isDraw {
            return 0}

        if maxmizing{
            // a very small value to be replaced by the upcoming value
            var bestVal = Int.min
            for move in validMoves{
               let result = minimax(board.move(move), maxmizing: false, player: player, depth: depth-1, &alpha, &beta)
                bestVal = max(result, bestVal)
                alpha = max(bestVal, alpha)
                if beta <= alpha{
                    break
                }
                
            }
        return bestVal
        }
        //minimizing
        else{
            // a very large value to be replaced by the any value
            var WorstVal = Int.max
            for move in validMoves {
                let result = minimax(board.move(move), maxmizing: true, player: player, depth: depth-1, &alpha, &beta)
                WorstVal = min(result, WorstVal)
                beta = min(beta, WorstVal)
                if beta <= alpha{
                    break
                }
            }
        return WorstVal
        }
        
    }
    // to run minmax() function on every available valid position
    func findBestMove(_ board: Board, depth: Int) ->Move{
        if validMoves.count == 9{
            return validMoves.randomElement()!
        }
        var alpha = Int.min
        var beta = Int.max
        var bestVal = Int.min
        var bestMove = -1

        for move in board.validMoves{
            let result = minimax(board.move(move), maxmizing: false, player: board.turn, depth: depth, &alpha, &beta)
            if result > bestVal{
                bestVal = result
                bestMove = move
            }
        }
    return bestMove
        
    }
    
    func updateScore(_ xScore: inout Int,_ oScore: inout Int){
        switch turn {
        case .X:
            oScore += 1
        case.O:
            xScore += 1
        default:
            break
        }
     }
    
    
}
