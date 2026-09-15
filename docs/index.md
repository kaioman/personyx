# 設計ドキュメント

Personyx の設計情報への入口です。現行の実装と README を基準に、責務、構造、業務上の前提、開発規約を整理しています。

## 推奨参照順

1. [概要](reference/overview.md)
2. [アーキテクチャ](reference/architecture.md)
3. [業務ルール](reference/business_rules.md)
4. [アーキテクチャルール](reference/architecture_rules.md)
5. [ディレクトリルール](reference/directory_rules.md)
6. [命名ルール](reference/naming_rules.md)
7. [コーディングルール](reference/coding_rules.md)
8. [テストルール](reference/testing_rules.md)
9. [運用手順](reference/operations.md)

## 文書の扱い

これらは既存の実装を説明するために新規作成した設計文書です。実装と文書に差異がある場合は、業務ルールと運用影響を確認したうえで、実装または文書のどちらを正とするかを決定してください。特に「要設計変更」と記載した項目は、コード変更前に方針を確定してください。

今後仕様を追加する場合は対応する文書へ追記し、実装との照合結果を更新してください。必要に応じて `docs-prompt --mode update` を使用して更新用プロンプトを出力し、Agentに修正を依頼してください。
