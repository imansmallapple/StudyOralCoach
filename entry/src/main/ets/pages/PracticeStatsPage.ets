import { router } from '@kit.ArkUI'
import { common } from '@kit.AbilityKit'
import { MaterialQuestionAnswerRecord } from '../model/StudyMaterialRecord'
import { MaterialIngestionService } from '../services/MaterialIngestionService'

@Entry
@Component
struct PracticeStatsPage {
  @State practicedQuestions: MaterialQuestionAnswerRecord[] = []
  @State isLoading: boolean = true

  aboutToAppear(): void {
    const context = getContext(this) as common.UIAbilityContext
    const service = new MaterialIngestionService(context)
    service.listPracticedQuestions(1000).then((items: MaterialQuestionAnswerRecord[]) => {
      this.practicedQuestions = items
      this.isLoading = false
    }).catch((err: Error) => {
      console.error('[StudyOralPracticed] load failed: ' + JSON.stringify(err))
      this.isLoading = false
    })
  }

  private formatTime(timestamp: string): string {
    const value = Number(timestamp)
    if (value <= 0) {
      return ''
    }
    const date = new Date(value)
    return (date.getMonth() + 1).toString() + '/' + date.getDate().toString() + ' ' +
      date.getHours().toString().padStart(2, '0') + ':' + date.getMinutes().toString().padStart(2, '0')
  }

  @Builder
  private practicedCard(item: MaterialQuestionAnswerRecord) {
    Column() {
      Row() {
        Text('Practiced ' + item.practiceCount.toString() + 'x')
          .fontSize(12)
          .fontColor('#1655FF')
          .fontWeight(FontWeight.Bold)
        Blank()
        Text(this.formatTime(item.lastPracticedAt))
          .fontSize(12)
          .fontColor('#59627E')
      }
      .width('100%')

      Text(item.question)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor('#111936')
        .lineHeight(22)
        .width('100%')
        .margin({ top: 10 })

      Text(item.answer)
        .fontSize(13)
        .fontColor('#3F4966')
        .lineHeight(20)
        .width('100%')
        .margin({ top: 10 })
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .border({ width: 1, color: '#E6EAF4' })
    .margin({ bottom: 12 })
  }

  build() {
    Column() {
      Row() {
        Text('‹').fontSize(34).fontColor('#111936').onClick(() => router.back())
        Text('Practiced').fontSize(18).fontWeight(FontWeight.Bold).fontColor('#111936').layoutWeight(1).textAlign(TextAlign.Center)
        Blank().width(34)
      }
      .height(58)
      .padding({ left: 18, right: 18, top: 8 })

      Scroll() {
        Column() {
          if (this.isLoading) {
            Text('Loading practiced questions...')
              .fontSize(14)
              .fontColor('#59627E')
              .width('100%')
              .textAlign(TextAlign.Center)
              .margin({ top: 32 })
          } else if (this.practicedQuestions.length === 0) {
            Image($r('app.media.ic_practice')).width(64).height(64).objectFit(ImageFit.Contain).margin({ top: 28 })
            Text('No practiced questions yet.')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#111936')
              .margin({ top: 12 })
            Text('Start practice from the uploaded question bank.')
              .fontSize(13)
              .fontColor('#59627E')
              .lineHeight(20)
              .textAlign(TextAlign.Center)
              .margin({ top: 8 })
          } else {
            Text(this.practicedQuestions.length.toString() + ' practiced questions')
              .fontSize(13)
              .fontColor('#59627E')
              .width('100%')
              .margin({ bottom: 14 })
            ForEach(this.practicedQuestions, (item: MaterialQuestionAnswerRecord) => {
              this.practicedCard(item)
            }, (item: MaterialQuestionAnswerRecord) => item.id)
          }
        }
        .width('100%')
        .padding({ left: 18, right: 18, top: 16, bottom: 24 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FDFEFF')
  }
}
