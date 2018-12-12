void drawPrompt() {
  fill(#131317);
  
  if (userDone) {
    textSize(60);
    text("User completed " + TRIAL_COUNT + " trials", width/2, height/2 + 100 + FONT_SIZE * 3.0);
    text("User took " + nfc((finishTime-startTime)/1000f/TRIAL_COUNT, 1) + " sec per target", width/2, height/2 + 100 + FONT_SIZE * 4.5);
    return;
  }
  
  text("Trial " + (trialIndex+1) + " of " +TRIAL_COUNT, width/2, height/2 + 100);
  text("Target #" + (currTarget.target+1), width/2, height/2 + 100 + FONT_SIZE * 1.5);
  
  fill(#ffffff);
  textSize(240);
  textAlign(CENTER, CENTER);
  //text("" + (currTarget.action == 0 ? LEFT : RIGHT), width/2, height * 3 / 12);
}
