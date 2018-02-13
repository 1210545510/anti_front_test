<div class="case_list_box table_layout">

  <!-- 搜索条件 -->
  <div class="search_toolBar clearfix">

    <div class="search_toolBar_row clearfix">
      <div class="fLeft search_item">
        <span class="search_name">Create Date:</span>
        <el-date-picker
          v-model="searchValues.createDateSelect"
          type="daterange"
          size="small"
          start-placeholder="Start Date"
          end-placeholder="End Date">
        </el-date-picker>
      </div>

      <div class="fLeft search_item">
        <span class="search_name search_name1">Due Date:</span>
        <el-date-picker
          v-model="searchValues.dueDateSelect"
          type="daterange"
          size="small"
          start-placeholder="Start Date"
          end-placeholder="End Date">
        </el-date-picker>
      </div>

      <div class="fRight search_btn_warp">
        <el-input placeholder="Scenario"
          v-model="searchValues.searchScenario"
          :maxlength="50"
          @keyup.enter.native="searchKeyword(searchValues.searchScenario, 'scenario')"
          class="input-with-select">
          <el-button slot="append"
          icon="el-icon-search"
          @click="searchKeyword(searchValues.searchScenario, 'scenario')"></el-button>
        </el-input>
      </div>
      <div class="fRight search_btn_warp">
        <el-input placeholder="Geography"
          v-model="searchValues.searchGeography"
          :maxlength="50"
          @keyup.enter.native="searchKeyword(searchValues.searchGeography, 'geography')"
          class="input-with-select">
          <el-button slot="append"
          icon="el-icon-search"
          @click="searchKeyword(searchValues.searchGeography, 'geography')"></el-button>
        </el-input>
      </div>
      <div class="fRight search_btn_warp" style="margin: 0">
        <el-input placeholder="Alert / Case ID"
          v-model="searchValues.searchCaseID"
          :maxlength="20"
          @keyup.enter.native="searchKeyword(searchValues.searchCaseID, 'caseID')"
          class="input-with-select">
          <el-button slot="append"
          icon="el-icon-search"
          @click="searchKeyword(searchValues.searchCaseID, 'caseID')"></el-button>
        </el-input>
      </div>
    </div>

    <div class="search_toolBar_row clearfix">
      <div class="fLeft search_item">
        <span class="search_name">Score:</span>
        <div class="search_range_box">
          <el-input class="" v-model="searchValues.startScore" placeholder="Min Score" :maxlength="9"></el-input>
          <span class="line_separator">-</span>
          <el-input class="" v-model="searchValues.endScore" placeholder="Max Score" :maxlength="9"></el-input>
        </div>
      </div>

      <div class="fLeft search_item">
        <span class="search_name search_name1">Amount:</span>
        <div class="search_range_box">
          <el-input class="" v-model="searchValues.startAmount" placeholder="Min Amount" :maxlength="20"></el-input>
          <span class="line_separator">-</span>
          <el-input class="" v-model="searchValues.endAmount" placeholder="Max Amount" :maxlength="20"></el-input>
        </div>
      </div>
    </div>

    <div class="search_toolBar_row clearfix">
      <div class="fLeft search_item">
        <span class="search_name">Case Type:</span>
        <el-select v-model="searchValues.caseTypeSelect" placeholder="Select Case Type">
          <el-option
            v-for="item in caseTypeOptions"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
      </div>

      <div class="fLeft search_item">
        <span class="search_name search_name1">Volume:</span>
        <div class="search_range_box">
          <el-input class="" v-model="searchValues.startVolume" placeholder="Min Volume" :maxlength="9"></el-input>
          <span class="line_separator">-</span>
          <el-input class="" v-model="searchValues.endVolume" placeholder="Max Volume" :maxlength="9"></el-input>
        </div>
      </div>
    </div>

    <div class="search_toolBar_row search_toolBar_btn_row clearfix">
      <div class="fLeft search_item">
        <el-button type="success" @click="screenSearch" v-if="isShowMenuItem(10147)">Search</el-button>
      </div>
      <div class="fRight search_btn_group">
        <el-button @click="SARFiling" v-if="isShowMenuItem(10149)">SAR Filing</el-button>
        <el-button @click="reArrangeHeading" v-if="isShowMenuItem(10149)">Re-arrange Headings</el-button>
        <el-button @click="exportCSV" v-if="isShowMenuItem(10151)">Export CSV</el-button>
      </div>
    </div>
  </div>

  <!-- table -->
  <el-table
    ref="multipleTable"
    :data="tableData"
    tooltip-effect="dark"
    style="width: 100%"
    @sort-change=sortChange
    :row-class-name="tableRowClassName"
    @selection-change="handleSelectionChange">
    <el-table-column
      type="selection"
      width="40">
    </el-table-column>
    <el-table-column
      label="Case ID"
      prop="caseId"
      width="120">
      <template slot-scope="scope">
        <el-tooltip class="item" effect="dark" :content="String(scope.row.caseId)" placement="top-start" :open-delay=400>
          <i>{{ scope.row.caseId }}</i>
        </el-tooltip>
      </template>
    </el-table-column>
    <el-table-column
      label="Alert ID"
      prop="alertId"
      width="120">
      <template slot-scope="scope">
        <el-tooltip class="item" effect="dark" :content="String(scope.row.alertId)" placement="top-start" :open-delay=400>
          <i>{{ scope.row.alertId }}</i>
        </el-tooltip>
      </template>
    </el-table-column>
    <el-table-column
      prop="statusValue"
      label="Status"
      width="120">
      <template slot-scope="scope">
        <el-tooltip class="item" effect="dark" :content="scope.row.statusValue" placement="top-start" :open-delay=400>
          <i>{{ scope.row.statusValue }}</i>
        </el-tooltip>
      </template>
    </el-table-column>
    <el-table-column
      v-for="item in confirmHeading"
      :key="item"
      :label="item"
      :prop="tranformToHumpStr(item)"
      :sortable="isSortable(item, true)"
      width="120">
      <template slot-scope="scope">
        <span  v-if="item === 'Due Date'">
          <el-tooltip class="item" effect="dark" :content="formatYMD(scope.row.dueDate)" placement="top-start" :open-delay=400>
            <i>{{ formatYMD(scope.row.dueDate) }}</i>
          </el-tooltip>
        </span>
        <span  v-else-if="item === 'Create Date'">
          <el-tooltip class="item" effect="dark" :content="formatYMD(scope.row.createDate)" placement="top-start" :open-delay=400>
            <i>{{ formatYMD(scope.row.createDate) }}</i>
          </el-tooltip>
        </span>
        <span v-else-if="item === 'Amount'">
          <el-tooltip class="item" effect="dark" :content="scope.row.amount | isEmptyVal | formatUSD" placement="top-start" :open-delay=400>
            <i>{{ scope.row.amount | isEmptyVal | formatUSD }}</i>
          </el-tooltip>
        </span>
        <span v-else-if="item === 'Case Type'">
          <el-tooltip class="item" effect="dark" :content="scope.row.typeValue" placement="top-start" :open-delay=400>
            <i>{{ scope.row.typeValue }}</i>
          </el-tooltip>
        </span>
        <span  v-else-if="item === 'Business Date'">
          <el-tooltip class="item" effect="dark" :content="formatYMD(scope.row.businessDate)" placement="top-start" :open-delay=400>
            <i>{{ formatYMD(scope.row.businessDate) }}</i>
          </el-tooltip>
        </span>
        <span v-else>
          <el-tooltip class="item" effect="dark" :content="String(scope.row[tranformToHumpStr(item)])" placement="top-start" :open-delay=400>
            <i>{{ scope.row[tranformToHumpStr(item)] }}</i>
          </el-tooltip>
        </span>
      </template>
    </el-table-column>
    <el-table-column
      fixed="right"
      prop="action"
      label="Action"
      class-name="noPaddngRight"
      width="120">
      <template slot-scope="scope">
        <!-- <span v-if="scope.row.taskId  && roleId !== 10045 && roleId !== 10046 && roleId !== 10047 && roleId !== 10048 && roleId !== 10049"
        v-show="isShowMenuItem(10148)">
          <a class="link" href="javascript:void(0);"
            @click="batchAssign(scope.row.taskId, scope.row.caseId, scope.row.roleId, scope.row.teamCode)"
            >Assign</a>
          <span class="link_split">|</span>
        </span> -->
        <router-link class="link reviewLink" :to="{ name: 'caseReview', query: { caseId: scope.row.caseId }}">Review</router-link>
      </template>
    </el-table-column>
  </el-table>

  <!-- 分页 -->
  <el-pagination
    @size-change="handleSizeChange"
    @current-change="handleCurrentChange"
    :current-page="currentPage"
    :page-size="pageSize"
    layout="total, sizes, prev, pager, next, jumper"
    :total="total">
  </el-pagination>

  <!-- 改变表头弹框组件 -->
  <arrange-heading
    v-if="allheading.length > 0"
    :action-url="arrangeHeadingUrl"
    :visible-arrange-heading.async="dialogVisibleArr.dialogRerangeHeading"
    :all-heading="allheading"
    :checked-heading="checkedHeading"
    :disabled-heading="disabledHeading"
    :on-success="arrangeSuccessCallBack"
    @visibleChange="visibleArrangeHeading">
  </arrange-heading>

  <!-- SARFiling弹框  -->
  <el-dialog
    title="SAR Filing"
    :visible.sync="dialogVisibleArr.dialogSARFiling"
    width="32%">
    <div class="dialog_content dialogSARFiling_content dl_form">
      <div class="dl_form_item">
        <span class="dl_form_name">Case ID:</span>
        <el-input placeholder="Enter Case ID" style="width: 70%;"
          v-model="SARFilingValue.caseID"
          :maxlength="50">
        </el-input>
      </div>
      <div class="dl_form_item">
        <span class="dl_form_name">Report Number:</span>
        <el-input placeholder="Enter Report Number" style="width: 70%;"
          v-model="SARFilingValue.reportNo"
          :maxlength="50">
        </el-input>
      </div>
      <div class="dl_form_item">
        <span class="dl_form_name">Attachment:</span>
        <el-upload
          ref="upload"
          style="display: inline-block"
          :action="uploadUrl"
          :data="actionData"
          :on-preview="handlePreview"
          :on-success="uploadSuccess"
          :on-error="uploadError"
          :before-upload="uploadBefore"
          :limit="10">
          <el-button size="small" type="primary"><i class="el-icon-upload el-icon--left"></i>Upload File</el-button>
        </el-upload>
      </div>
    </div>
    <span slot="footer" class="dialog-footer">
      <el-button @click="dialogVisibleArr.dialogSARFiling = false">Cancle</el-button>
      <el-button type="primary" @click="confirmSARFiling">Save</el-button>
    </span>
  </el-dialog>

</div>
