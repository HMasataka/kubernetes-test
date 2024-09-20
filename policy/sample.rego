package main

# 評価結果は、violation / deny / warn / allow で選べる。名前を付ける場合、先頭の文字がいずれかに該当していれば ok
# violation と deny は ポリシーを満たすとダメ扱い。warn は警告扱い。BlackListでのポリシー評価が楽なので、allow は使わない
deny[msg] {
    # boolを返すルールを複数記述できる。入力は、外部ライブラリを使わない限り input に入ってくる。
    input.kind == "Deployment"
    not (input.spec.selector.matchLabels.app == input.spec.template.metadata.labels.app)
    msg = sprintf("Pod Template と Selector には同じ app ラベルを付与してください: %s", [input.metadata.name])
}

workload_resources := ["Deployment", "StatefulSet"]
is_deployment_or_statefulset {
	input.kind == workload_resources[_]
}
