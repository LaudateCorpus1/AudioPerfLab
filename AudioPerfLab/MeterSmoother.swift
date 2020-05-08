/*
 * Copyright (c) 2020 Ableton AG, Berlin
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

class MeterSmoother {
  private var peakInDb = -Double.infinity
  private var smoothedLevelInDb = -Double.infinity
  private var lastDisplayTime : Double?

  func addPeak(_ decibels: Double) {
    peakInDb = max(peakInDb, decibels)
  }

  func smoothedLevel(displayTime: Double) -> Double {
    let minLevelInDb = -70.0

    let elapsedTime = displayTime - (lastDisplayTime ?? displayTime)
    let falloffInDb = MeterSmoother.dbFalloffAfter(elapsedTime: elapsedTime)
    smoothedLevelInDb = max(smoothedLevelInDb - falloffInDb, peakInDb)
    if (smoothedLevelInDb < minLevelInDb) {
      smoothedLevelInDb = -Double.infinity
    }
    peakInDb = -Double.infinity
    lastDisplayTime = displayTime
    return smoothedLevelInDb
  }

  private static func dbFalloffAfter(elapsedTime: Double) -> Double {
    let dbDropPerSecond = 30.0
    return elapsedTime * dbDropPerSecond
  }
}
