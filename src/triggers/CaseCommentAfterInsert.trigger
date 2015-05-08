trigger CaseCommentAfterInsert on CaseComment (after insert, after update) {
  for (CaseComment each : trigger.new) {
    CaseCommentHelper.SendSomething(each.parentId,each.id , each.CommentBody);
  }
}