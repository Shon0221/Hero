// The MIT License (MIT)
//
// Copyright (c) 2016 Luke Zhao <me@lkzhao.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

class MatchPreprocessor: BasePreprocessor {
  override func process(fromViews: [UIView], toViews: [UIView]) {
    for tv in toViews {
      guard let id = tv.heroID, let fv = context.sourceView(for: id) else { continue }

      var tvState = context[tv] ?? HeroTargetState()
      var fvState = context[fv] ?? HeroTargetState()

      tvState.source = id
      fvState.source = id

      fvState.arc = tvState.arc
      fvState.duration = tvState.duration
      fvState.timingFunction = tvState.timingFunction
      fvState.delay = tvState.delay
      fvState.spring = tvState.spring

      tvState.opacity = 0
      if !fv.isOpaque || tv.alpha < 1 {
        // cross fade if fromView is not opaque or if toView is transparent
        fvState.opacity = 0
      } else {
        // no cross fade in this case, fromView is always displayed during the transition.
        fvState.opacity = nil

        // we dont want two shadows showing up. Therefore we disable toView's shadow when fromView is able to display its shadow
        if !fv.layer.masksToBounds && fvState.displayShadow {
          tvState.displayShadow = false
        }
      }

      context[tv] = tvState
      context[fv] = fvState
    }
  }
}
