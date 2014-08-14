class InvalidInputError < StandardError
end

class NoPieceAtThisLocationError < StandardError
end

class InvalidMoveError < StandardError
end

class MoveIntoCheckError < StandardError
end

class NoRookForCastlingError < StandardError
end

class CanNotCastlingError < StandardError
end

class WrongColorPieceError < StandardError
end
