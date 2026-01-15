# Spec R (Redmine PMBOK 6th Ed. Plugin) 基本設計書

## 1. プロジェクト概要
**Spec R** は、Redmineに**PMBOK（第6版）**に準拠したプロジェクト管理プロセスを追加するプラグインである。
既存のRedmine（タスク実行・監視）の上位レイヤーとして、**「立ち上げ」「計画」「監視・コントロール」**のプロセス群をシステム化し、プロジェクトの健全性を担保することを目的とする。

## 2. コンセプト & 解決する課題
* **課題:** Redmineは「実行プロセス（タスク消化）」には強いが、その前段階の「計画」や、俯瞰的な「監視」機能が不足している。
* **解決策:** PMBOK第6版の知識エリアに基づき、以下のプロセスを実装する。
    1.  **統合マネジメント:** プロジェクト憲章作成、プロジェクト作業の監視・コントロール（月報）。
    2.  **スコープ・マネジメント:** WBS作成。
    3.  **リソース・マネジメント:** リソース・ヒストグラム（山積み表）。

## 3. 機能要件 (Roadmap)

### Phase 1: 立ち上げと監視 (Initiating & Monitoring)
まずはプロジェクトの「定義」と「定点観測」を実装する。

* **📜 プロジェクト憲章 (Project Charter)**
    * **対応プロセス:** 立ち上げプロセス群
    * **機能:** プロジェクトの目的、ハイレベルな要件、前提条件、制約事項を定義・承認する画面。
    * **目的:** プロジェクトの正当性を定義し、PMの権限を明確化する。
* **📅 月次監視レポート (Monitor and Control Project Work)**
    * **対応プロセス:** 監視・コントロールプロセス群
    * **機能:** 予実の差異分析、変更要求の状況、リスク状況を月次で報告・記録する。
    * **入力項目:**
        * スケジュール差異 (SV) / コスト差異 (CV) の定性評価
        * 重要課題・リスクのステータス
        * 全体健全度 (R/G/Y 信号)
* **📊 統合ダッシュボード (MTR-2)**
    * 全プロジェクトの「月次レポート」の最新ステータス（信号）を一覧表示し、経営層・PMOが介入すべきプロジェクトを可視化する。

### Phase 2: 詳細計画 (Planning)
* **🏗 WBSツール (Create WBS)**
    * **対応プロセス:** スコープ・マネジメント
    * **機能:** 成果物ベースでスコープを分解し、Redmineチケットと紐付ける。
* **⛰ リソース山積み表 (Resource Histogram)**
    * **対応プロセス:** リソース・マネジメント
    * **機能:** 要員ごとの負荷状況を可視化し、リソースの平準化（Leveling）を支援する。

---

## 4. データベース設計案

### 4.1. project_charters (プロジェクト憲章)
プロジェクト立ち上げ時に作成される定義書。

| カラム名 | 対応PMBOK項目 | 型 |
| :--- | :--- | :--- |
| project_id | - | FK (1:1) |
| business_case | ビジネス・ケース | text |
| objective | プロジェクトの目的 | text |
| success_criteria | 成功基準 | text |
| key_deliverables | 主要な成果物 | text |
| high_level_risks | ハイレベル・リスク | text |
| pm_authority | PMの権限 | text |

### 4.2. monthly_reports (監視レポート)
「プロジェクト作業の監視・コントロール」プロセスのアウトプット。

| カラム名 | 説明 | 型 |
| :--- | :--- | :--- |
| project_id | 対象プロジェクト | FK |
| report_date | 報告基準日 | date |
| overall_health | 全体健全度 | enum (Red, Green, Yellow) |
| scope_status | スコープ状況 | enum |
| schedule_status | スケジュール状況 | enum |
| cost_status | コスト状況 | enum |
| executive_summary | エグゼクティブサマリ | text |
| issues_and_risks | 課題とリスク | text |
| planned_actions | 今後のアクション | text |

---

## 5. テクノロジースタック
| コンポーネント | 技術要素 |
| :--- | :--- |
| Infrastructure | Docker / Docker Compose |
| Database | PostgreSQL 15 |
| Backend | Ruby on Rails (Redmine core) |
| Frontend | ERB / JavaScript / Chart.js |