filetype plugin indent on
describe 'docstring folding'
  before
    new
    set filetype=python
  end
  after
    close!
  end
  it 'folds simple docstring'
    expect folds 1,2,2,2
      def f():
          """docstring here
          
          a long one"""
    end
  end
end
