class LineBotController < ApplicationController
  require "line/bot"

  def callback
    # LINEで送られてきたメッセージのデータを取得
    body = request.body.read

    # LINE以外からリクエストが来た場合 Error を返す
    signature = request.env["HTTP_X_LINE_SIGNATURE"]
    unless client.validate_signature(body, signature)
      head :bad_request and return
    end

    # LINEで送られてきたメッセージを適切な形式に変形
    events = client.parse_events_from(body)
    events.each do |event|
      # LINE からテキストが送信された場合
      if (event.type === Line::Bot::Event::MessageType::Text)
        # LINE からテキストが送信されたときの処理を記述する
        message = event["message"]["text"]

        # 送信されたメッセージをデータベースに保存するコードを書こう
        task = Task.new(content: message)

        if task.save
          reply_message = {
            type: "text",
            text: "タスク「#{message}」を登録しました" # LINE に返すメッセージを考えてみよう
          }
        else
          reply_message = {
            type: "text",
            text: "タスク「#{message}」の登録に失敗しました" # LINE に返すメッセージを考えてみよう
          }
        end
        client.reply_message(event["replyToken"], reply_message)
      end
    end

    # LINE の webhook API との連携をするために status code 200 を返す
    render json: { status: :ok }
  end

  private

    def client
      @client ||= Line::Bot::Client.new do |config|
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      end
    end
end
