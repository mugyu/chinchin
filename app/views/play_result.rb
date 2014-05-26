def play_result(result)
  erb :play_result, locals: {
    name: result.player.name,
    outcome: result.outcome,
    point: result.yaku ? result.yaku : result.point,
    tokens: result.player.tokens,
    dice_set: result.dice
  }
end
