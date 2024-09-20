package main

# 評価結果は、violation / deny / warn / allow で選べる。名前を付ける場合、先頭の文字がいずれかに該当していれば ok
# violation と deny は ポリシーを満たすとダメ扱い。warn は警告扱い。BlackListでのポリシー評価が楽なので、allow は使わない
deny[msg] {
    # boolを返すルールを複数記述できる。入力は、外部ライブラリを使わない限り input に入ってくる。
    input.kind == "Deployment"
    not (input.spec.selector.matchLabels.app == input.spec.template.metadata.labels.app)
    msg = sprintf("Pod Template と Selector には同じ app ラベルを付与してください: %s", [input.metadata.name])
}

recommended_labels {
	input.metadata.labels["app.kubernetes.io/name"]
	input.metadata.labels["app.kubernetes.io/instance"]
	input.metadata.labels["app.kubernetes.io/version"]
	input.metadata.labels["app.kubernetes.io/component"]
	input.metadata.labels["app.kubernetes.io/part-of"]
	input.metadata.labels["app.kubernetes.io/managed-by"]
}
workload_resources := ["Deployment", "StatefulSet"]

is_deployment_or_statefulset {
	input.kind == workload_resources[_]
}

# recommented labels must exists
violation_labels_recommended_exists[{"msg": msg}] {
	is_deployment_or_statefulset
	not recommended_labels

	msg = sprintf("推奨ラベルを付与してください。(https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/#labels): [Kind=%s,Name=%s]", [input.kind, input.metadata.name])
}
