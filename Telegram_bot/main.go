package main

import (
	"log"

	tgbotapi "github.com/go-telegram-bot-api/telegram-bot-api"
)

func main() {
	bot, err := tgbotapi.NewBotAPI("2042943135:AAF8XBGs_VEYnFSk3iNxlesDV5BFo0HlZZY")
	if err != nil {
		log.Panic(err)
	}
	bot.Debug = false

	log.Printf("Authorized on account %s", bot.Self.UserName)

	u := tgbotapi.NewUpdate(0)
	u.Timeout = 60

	updates, err := bot.GetUpdatesChan(u)

	for update := range updates {
		if update.Message == nil {
			continue
		}

		log.Printf("[%s] %s", update.Message.From.UserName, update.Message.Text)

		if update.Message.IsCommand() {
			msg := tgbotapi.NewMessage(update.Message.Chat.ID, "")
			switch update.Message.Command() {
			case "start":
				msg.Text = "devops-course repo.\nI can show you available commands by /help"
			case "help":
				msg.Text = "Available commands:\n/start\n/help\n/git\n/aboutme\n/til\n/tasks\n/task1\n/task2\n/task3\n/task4"
			case "git":
				msg.Text = "https://github.com/RusYakup/devops-course"
			case "tasks":
				msg.Text = "AboutMe\n TIL\n1. Ansible task\n2. Bash script task\n3. Telegram bot\n4"
			case "aboutme":
				msg.Text = "https://github.com/RusYakup/devops-course/blob/main/README.md"
			case "til":
				msg.Text = "https://github.com/RusYakup/devops-course/blob/main/til/til.md"
			case "task1":
				msg.Text = "https://github.com/RusYakup/devops-course/tree/main/Flask_ansible"
			case "task2":
				msg.Text = "https://github.com/RusYakup/devops-course/tree/main/task2_bash_script"
			case "task3":
				msg.Text = "https://github.com/RusYakup/devops-course/tree/main/Telegram_bot"
			case "task4":
				msg.Text = "https://github.com/RusYakup/devops-course/tree/main/docker_flask"



			default:
				msg.Text = "/help \n"
			}
			bot.Send(msg)
		}

	}
}
